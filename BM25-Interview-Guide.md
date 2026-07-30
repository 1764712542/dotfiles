# BM25 稀疏检索 — AI 应用工程师面试完全指南

---

## 1. 核心概念

### 什么是 BM25

BM25（Best Matching 25）是一种**稀疏检索**（Sparse Retrieval）排序算法，用于计算查询与文档之间的相关性分数。它是 TF-IDF 的继承者和升级版，也是 Elasticsearch 的默认相似度算法。

| 属性 | 说明 |
|------|------|
| 全称 | Best Matching 25 |
| 类型 | 稀疏检索、词袋模型（Bag of Words） |
| 本质 | 基于分词、词频（TF）、逆文档频率（IDF）、文档长度做相关性打分 |
| 能力边界 | **只看字面关键词匹配，不理解语义** |
| 索引结构 | 倒排索引（Inverted Index） |

### 为什么叫 BM25

- **BM** = Best Matching，Robertson 和 Sparck Jones 提出的概率检索框架
- **25** = 第 25 次迭代版本（Okapi 项目中演进到第 25 版）

### 与稠密检索的对比

| 维度 | BM25（稀疏检索） | Embedding 向量检索（稠密检索） |
|------|------------------|-------------------------------|
| 索引结构 | 倒排索引 | HNSW / IVF 向量索引 |
| 匹配方式 | 关键词精确匹配 | 语义相似度（余弦/IP/点积） |
| 理解能力 | 无语义理解 | 有语义理解 |
| 同义词处理 | 不处理（只认字面） | 天然支持（embedding 相近） |
| 冷启动 | 不需要训练 | 需要预训练模型 |
| 延迟 | 低（毫秒级） | 较高（需向量计算） |
| 可解释性 | 高（每个词贡献可分解） | 低（黑盒） |

---

## 2. 数学公式与参数详解

### 完整公式

```
score(D, Q) = Σ IDF(qi) × [ f(qi, D) × (k1 + 1) ] / [ f(qi, D) + k1 × (1 - b + b × |D|/avgdl) ]
```

其中：
- $D$ = 文档，$Q$ = 查询（由 $n$ 个词项 $q_i$ 组成）
- $f(q_i, D)$ = 词项 $q_i$ 在文档 $D$ 中的词频（Term Frequency）
- $|D|$ = 文档 $D$ 的长度（词数）
- $\text{avgdl}$ = 整个文档集合的平均文档长度

### 参数详解

#### $k_1$ — 词频饱和度控制

| 取值 | 效果 |
|------|------|
| $k_1 = 0$ | 相当于不考虑词频，只算 IDF |
| $k_1 = 1.2$ （默认） | 标准 BM25，Elasticsearch 默认值 |
| $k_1 \to \infty$ | 退化为纯 TF-IDF（无饱和度限制） |
| $k_1 = 2.0$ | 更强调高频词的区分度 |

**作用**：控制词频的饱和度。一个词在文档中出现次数越多，分数越高，但这种增长是**边际递减**的。$k_1$ 越小，饱和越快（出现几次后就"够了"）。

#### $b$ — 文档长度归一化

| 取值 | 效果 |
|------|------|
| $b = 0$ | 不做长度归一化 |
| $b = 0.75$（默认） | 标准 BM25，Elasticsearch 默认值 |
| $b = 1$ | 完全长度归一化 |

**作用**：长文档通常包含更多词，可能"刷分"。$b$ 控制对文档长度的惩罚程度。$b$ 越大，长文档需要更高的关键词密度才能获得同等分数。

### IDF 的计算

BM25 的 IDF 与经典不同，有平滑处理：

```
IDF(qi) = log((N - n(qi) + 0.5) / (n(qi) + 0.5) + 1)
```

其中 $N$ = 文档总数，$n(q_i)$ = 包含词项 $q_i$ 的文档数。

**面试易错点**：不要直接说 `log(N/n)` — 面试官会追问为什么 BM25 要加 0.5 和 1。

### 公式直觉

1. **词频（TF）项**：该词在文档中出现越多 → 分数越高（但有边际递减）
2. **IDF 项**：该词越罕见 → 区分度越高 → 权重越大（"的"、"了"等停用词 IDF 极低）
3. **长度归一化**：文档越短 → 同样的词频意味着更高的关键词密度 → 分数越高

---

## 3. BM25 vs TF-IDF vs 向量检索

### BM25 比 TF-IDF 好在哪

| 改进点 | TF-IDF | BM25 |
|--------|--------|------|
| 词频饱和度 | 线性增长（无上限） | 非线性饱和（边际递减） |
| 文档长度归一化 | 简单/无 | 可调参数 $b$ |
| IDF 平滑 | 基础 $N/n$ | 平滑 + 防负值 |
| 理论支撑 | 经验公式 | 概率检索框架（PRP） |
| 参数可调性 | 几乎无 | $k_1$ 和 $b$ 可调 |

### 何时选 BM25 vs 向量检索

| 场景 | 推荐 |
|------|------|
| 精确关键词匹配（工单、法规、合同） | BM25 |
| 商品标题/名称搜索 | BM25 |
| 同义词/语义搜索 | 向量检索 |
| 跨语言搜索（中→英） | 向量检索 |
| 长文档检索 | BM25 + 向量混合 |
| RAG 系统 | 混合检索（BM25 + 向量） |

---

## 4. 工程实现细节

### 倒排索引结构

```
词项 → { (文档 ID, 词频), (文档 ID, 词频), ... }
"苹果" → { (doc1, 3), (doc2, 1), (doc5, 7) }
"手机" → { (doc1, 2), (doc3, 4) }
```

### 实时索引更新策略

| 策略 | 描述 | 适用场景 |
|------|------|---------|
| 全量重建 | 重建完整倒排索引 | 数据量小、变更不频繁 |
| 增量更新 | 追加新文档倒排项，更新 IDF 统计 | 实时写入场景 |
| 分段合并（ES） | 新数据写入新段，后台合并 | 写多读少、日志场景 |

### BM25 在 Elasticsearch 中的配置

```json
{
  "settings": {
    "similarity": {
      "default": {
        "type": "BM25",
        "k1": 1.2,
        "b": 0.75
      }
    }
  }
}
```

---

## 5. BM25 变体

| 变体 | 解决的问题 | 典型场景 |
|------|-----------|---------|
| BM25 标准 | 通用 | 默认选择 |
| BM25+ | 长文档惩罚过重（短查询场景） | 网页搜索 |
| BM25F | 多字段权重不均 | 结构化文档搜索 |
| BM25L | 超长文档（论文、书籍） | 学术搜索 |

### BM25+（带下界）

公式增加一个常数 $\delta$（通常 0.5~1.0）：

```
score += IDF × (TF项 + δ)
```

短查询场景下长文档也能获得基础分。

### BM25F（Field-Weighted）

不同字段（title、body、tags）赋予不同权重，各字段频率独立计算后加权求和。

---

## 6. 生产系统中的应用

### Elasticsearch 查询

```json
GET /my_index/_search
{
  "query": {
    "match": {
      "content": {
        "query": "AI transformer attention",
        "boost": 2.0
      }
    }
  }
}
```

### Milvus — Hybrid Search

```python
collection.hybrid_search(
    reqs=[
        {"data": [dense_emb], "anns_field": "dense_vector",
         "param": {"metric_type": "IP"}, "limit": 100},
        {"data": [query_text], "anns_field": "sparse_vector",
         "param": {"metric_type": "BM25"}, "limit": 100}
    ],
    rerank=WeightedRanker(0.5, 0.5),
    limit=10
)
```

### Chroma — 不支持内置 BM25

Chroma 只有稠密检索。需要手写 BM25 后合并：

```python
from rank_bm25 import BM25Okapi
bm25 = BM25Okapi([doc.split() for doc in docs])
sparse_scores = bm25.get_scores(query.split())
# 与 Chroma 稠密结果 RRF 合并
```

### Pinecone — Hybrid Search

```python
index.query(
    vector=dense_query,
    sparse_vector=bm25_sparse(query),
    alpha=0.5,
    top_k=10
)
```

---

## 7. BM25 + Dense Retrieval 混合检索

### 为什么需要混合

| 检索方式 | 优点 | 缺点 |
|----------|------|------|
| BM25 纯关键词 | 精确匹配、可解释 | 语义无关、同义词失效 |
| 纯向量检索 | 语义匹配、同义词 | 精度不稳定、domain shift |
| **混合检索** | **兼顾两者** | **需要调权重、多一次检索** |

### 混合策略

#### 1. RRF（Reciprocal Rank Fusion）

```
RRFScore(d) = Σ 1 / (k + rank_of_d)
```

- 不考虑分数绝对值，只考虑排名位置
- k 通常取 60
- 鲁棒性最强，不需要对齐分数

#### 2. Weighted Sum

```
HybridScore = α × norm(BM25Score) + (1 - α) × norm(DenseScore)
```

- 需要对分数做归一化（min-max / z-score）
- α 通常 0.3 ~ 0.7

#### 3. 两阶段检索（Cascaded）

```
Query → BM25 粗筛（top-200）→ Dense 精排（top-10）
```

- 性能更好：BM25 快，向量只在少量文档上做
- 推荐给延迟敏感的 RAG 系统

### 场景推荐配置

| 场景 | 推荐策略 | 权重 |
|------|---------|------|
| 问答系统（事实性） | RRF | — |
| 通用搜索 | Weighted Sum | BM25: 0.3, Dense: 0.7 |
| 专业文档搜索 | Cascaded | BM25 优先 |
| 同义词丰富场景 | Weighted Sum | BM25: 0.2, Dense: 0.8 |

---

## 8. 参数调优实践

### $k_1$ 建议值

| 场景 | 建议 $k_1$ |
|------|-----------|
| 通用网页搜索 | 1.2（默认） |
| 长文档（论文） | 1.5 ~ 2.0 |
| 短文本（标题） | 0.8 ~ 1.2 |
| 问答（精确匹配） | 0.5 ~ 1.0 |
| 代码搜索 | 1.0 ~ 1.5 |

### $b$ 建议值

| 文档长度分布 | 建议 $b$ |
|-------------|---------|
| 等长文档（日志） | 0 ~ 0.3 |
| 混合长度（网站） | 0.75（默认） |
| 长度差异极大 | 0.9 ~ 1.0 |

---

## 9. 面试高频问题与回答

### 基础题

**Q1: BM25 和 TF-IDF 的核心区别？**

三点：① 词频饱和度（边际递减 vs 线性增长）；② 文档长度归一化（可调参数 b）；③ 概率检索理论支撑。TF-IDF 是纯经验公式，BM25 有 Robertson 的概率检索框架（PRP）。

**Q2: k1 和 b 分别控制什么？**

k1 控制词频饱和速度，越大高频词贡献越大。b 控制文档长度归一化强度，越大对长文档惩罚越重。默认 k1=1.2, b=0.75。

**Q3: BM25 的局限性？**

① 纯字面匹配，不理解语义；② 词袋模型，忽略词序；③ 跨语言完全不可用；④ 对无关键词查询（"帮我找个好工具"）效果极差。

**Q4: 为什么 Elasticsearch 5.0 从 TF-IDF 改到 BM25？**

BM25 在实际效果上全面优于 TF-IDF，且可调参数提供了更好的场景适配性。

### 进阶题

**Q5: BM25 在 RAG 中的应用方式？**

混合检索：BM25 精确召回（人名/编号/术语） + 向量语义召回 → RRF/Weighted Sum 融合 → Cross-Encoder 重排 → LLM 生成。BM25 保证了精确匹配不丢失。

**Q6: BM25 IDF 会不会为负？**

标准 BM25 的 IDF 公式加了 +1 和 0.5 平滑，保证非负。朴素 log(N/n) 在 n > N/2 时会为负，BM25 公式有意规避了这个问题。

**Q7: BM25 分数能跨索引比较吗？**

不能。IDF 和 avgdl 强依赖当前文档集合统计。不同索引分数不在同一尺度。

### 场景题

**Q8: 搜索"苹果手机"但搜不到"iPhone"文档，怎么解决？**

这是 BM25 的典型局限。解法：① 混合检索（BM25 + 向量）；② 查询扩展（同义词词典 / LLM 生成同义查询）；③ 索引时做同义词扩展。

**Q9: RAG 总是漏掉含精确关键词的文档，怎么办？**

① 增大 BM25 在混合检索中的权重；② 检查 k1/b 是否适合文档分布；③ 先 BM25 粗筛再向量精排。

---

## 10. 代码实现（从零实现 BM25）

```python
import math
from collections import Counter
from typing import List

class BM25:
    def __init__(self, corpus: List[List[str]], k1: float = 1.2, b: float = 0.75):
        self.k1 = k1
        self.b = b
        self.corpus = corpus
        self.doc_len = [len(doc) for doc in corpus]
        self.avgdl = sum(self.doc_len) / len(corpus)
        self.N = len(corpus)
        self.idf = self._compute_idf()
    
    def _compute_idf(self):
        df = Counter()
        for doc in self.corpus:
            for word in set(doc):
                df[word] += 1
        return {
            w: math.log((self.N - df[w] + 0.5) / (df[w] + 0.5) + 1)
            for w in df
        }
    
    def _score_one(self, query, doc_idx):
        score = 0.0
        doc_words = Counter(self.corpus[doc_idx])
        norm = 1 - self.b + self.b * (self.doc_len[doc_idx] / self.avgdl)
        for word in query:
            if word not in self.idf:
                continue
            tf = doc_words.get(word, 0)
            if tf == 0:
                continue
            score += self.idf[word] * (tf * (self.k1 + 1)) / (tf + self.k1 * norm)
        return score
    
    def get_scores(self, query):
        return [self._score_one(query, i) for i in range(self.N)]

# 使用
corpus = [doc.split() for doc in [
    "苹果公司发布了新款iPhone手机",
    "华为推出了Mate系列旗舰手机",
    "小米性价比高的手机推荐",
    "苹果手机的系统是iOS非常流畅",
]]
bm25 = BM25(corpus)
scores = bm25.get_scores("苹果 手机".split())
# doc0 和 doc3 分数最高
```

---

## 11. RAG 场景中的 BM25

### BM25 在 RAG 链路中的位置

```
Query
 ├──→ BM25（关键词召回）── 精确匹配（人名/编号/术语）
 ├──→ Dense（语义召回） ── 语义匹配（同义改写）
 ├──→ RRF / Weighted Fusion
 ├──→ Re-ranker（Cross-Encoder）
 └──→ LLM → 最终回复
```

### 为什么 RAG 离不开 BM25

| 场景 | 向量检索的问题 | BM25 解决 |
|------|---------------|-----------|
| 搜索"2024Q3财报" | 召回到"2023Q4" | 精确命中 Q3/2024 |
| 搜索"Bug-12345" | 不理解编码 | 精确匹配工单号 |
| 搜索"第7条违约责任" | 语义接近"第5条赔偿" | 精确命中条款 |
| 搜索"Python 3.12" | 版本号易混淆 | 精确匹配 3.12 |

### BM25 在 RAG 中的工程注意事项

1. **chunk 后 IDF 失真**：chunk 太小导致 IDF 统计不准 → 在原始文档级计算 IDF
2. **query 过短**：用户 query 通常 2-5 词 → 用 LLM 做 query 扩展
3. **IDF 老化**：增量写入后 IDF 需更新 → 定期重建统计
4. **多字段加权**：title 和 body 权重不同 → BM25F 或 `boost`

---

## 12. 常见误区与陷阱

| 误区 | 纠正 |
|------|------|
| "BM25 分数可以跨索引比较" | IDF 和 avgdl 依赖具体文档集合，不能跨索引比较 |
| "BM25 理解语义" | 纯字面匹配，"苹果"和"iPhone"在 BM25 眼里无关 |
| "k1 越大越好" | 过大会导致"刷词"问题 |
| "混合检索 α 默认 0.5" | 最优 α 随场景差异很大（0.2~0.8） |
| "BM25 默认参数就够" | 默认 k1=1.2, b=0.75 是通用值，特定场景调优可提升 10-20% |
| "Chroma 支持 BM25" | Chroma 没有内置 BM25，需要外部库 |
