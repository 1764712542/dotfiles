# 机器学习与深度学习参考手册

> 适用环境: macOS Apple Silicon · Python 3.12 · PyTorch · MLX
> 最后更新: 2026-06-19

---

## 目录

1. [环境配置](#1-环境配置)
2. [数据科学基础](#2-数据科学基础)
3. [机器学习 (Scikit-learn)](#3-机器学习-scikit-learn)
4. [深度学习 (PyTorch)](#4-深度学习-pytorch)
5. [MLX (Apple Silicon)](#5-mlx-apple-silicon)
6. [Hugging Face Transformers](#6-hugging-face-transformers)
7. [计算机视觉](#7-计算机视觉)
8. [NLP 与 LLM](#8-nlp-与-llm)
9. [训练优化](#9-训练优化)
10. [实验管理](#10-实验管理)
11. [部署](#11-部署)
12. [学习路线](#12-学习路线)

---

## 1. 环境配置

### Python 环境

```bash
# 使用 uv（推荐，比 pip 快 10-100x）
uv venv ml-env
source ml-env/bin/activate

# 或使用 conda
conda create -n ml-env python=3.12
conda activate ml-env
```

### 核心库安装

```bash
# 数据科学基础
uv pip install numpy pandas matplotlib seaborn scipy

# 机器学习
uv pip install scikit-learn

# 深度学习 (macOS Apple Silicon)
uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cpu

# 深度学习 (CUDA)
uv pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

# Apple Silicon 优化
uv pip install mlx mlx-lm

# Hugging Face
uv pip install transformers datasets accelerate peft trl

# 训练可视化
uv pip install tensorboard wandb

# XGBoost / LightGBM
uv pip install xgboost lightgbm

# Jupyter
uv pip install jupyterlab ipywidgets
```

### 验证安装

```python
import torch
import sklearn
import numpy as np

print(f"PyTorch: {torch.__version__}")
print(f"scikit-learn: {sklearn.__version__}")
print(f"MPS 可用: {torch.backends.mps.is_available()}")  # Apple Silicon
print(f"CUDA 可用: {torch.cuda.is_available()}")
```

---

## 2. 数据科学基础

### NumPy

```python
import numpy as np

# 创建数组
a = np.array([1, 2, 3])
b = np.zeros((3, 4))
c = np.ones((2, 3))
d = np.arange(10)
e = np.linspace(0, 1, 5)
f = np.random.randn(3, 3)

# 形状操作
a.shape          # 形状
a.reshape(3, 1)  # 重塑
a.flatten()      # 展开
np.concatenate([a, a])  # 拼接
np.stack([a, a])         # 堆叠

# 数学运算
np.mean(a)       # 均值
np.std(a)        # 标准差
np.sum(a)        # 求和
np.dot(a, a)     # 点积
np.matmul(x, y)  # 矩阵乘法

# 广播
a = np.array([[1], [2], [3]])     # (3, 1)
b = np.array([10, 20, 30])        # (3,)
c = a + b                          # (3, 3) 广播
```

### Pandas

```python
import pandas as pd

# 读取数据
df = pd.read_csv("data.csv")
df = pd.read_excel("data.xlsx")
df = pd.read_parquet("data.parquet")
df = pd.read_json("data.json")

# 基本查看
df.head()          # 前5行
df.info()          # 列信息
df.describe()      # 统计摘要
df.shape           # 形状
df.columns         # 列名
df.dtypes          # 数据类型

# 数据清洗
df.isnull().sum()      # 缺失值统计
df.dropna()            # 删除缺失行
df.fillna(value)       # 填充缺失值
df.duplicated().sum()  # 重复值
df.drop_duplicates()   # 删除重复
df["col"] = df["col"].astype("float32")  # 类型转换

# 筛选与查询
df[df["age"] > 30]
df.query("age > 30 and gender == 'M'")
df[["col1", "col2"]]
df.loc[0:10, ["col1", "col2"]]
df.iloc[0:10, 0:3]

# 分组聚合
df.groupby("category")["value"].mean()
df.pivot_table(index="date", columns="category", values="value")
df.groupby("category").agg({"value": ["mean", "std"]})

# 日期处理
df["date"] = pd.to_datetime(df["date"])
df.set_index("date", inplace=True)
df.resample("M").mean()  # 按月重采样
```

### Matplotlib & Seaborn

```python
import matplotlib.pyplot as plt
import seaborn as sns

# 全局设置
plt.rcParams.update({
    "figure.figsize": (10, 6),
    "figure.dpi": 100,
    "font.size": 12,
})

# 折线图
plt.plot(x, y, label="Line")
plt.xlabel("X")
plt.ylabel("Y")
plt.title("Title")
plt.legend()
plt.show()

# 散点图
plt.scatter(x, y, c=colors, alpha=0.5)
plt.colorbar()

# 直方图
plt.hist(data, bins=50, alpha=0.7)

# 子图
fig, axes = plt.subplots(2, 3, figsize=(15, 8))
axes[0, 0].plot(x, y)

# Seaborn (统计图)
sns.heatmap(df.corr(), annot=True, cmap="coolwarm")
sns.pairplot(df, hue="target")
sns.boxplot(x="category", y="value", data=df)
sns.violinplot(x="category", y="value", data=df)
sns.distplot(data, bins=50)
sns.scatterplot(x="col1", y="col2", hue="target", data=df)
```

---

## 3. 机器学习 (Scikit-learn)

### 数据预处理

```python
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, MinMaxScaler, LabelEncoder
from sklearn.impute import SimpleImputer

# 划分数据集
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

# 标准化 (Z-score)
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# 归一化 (0-1)
scaler = MinMaxScaler()
X_train_norm = scaler.fit_transform(X_train)

# 标签编码
le = LabelEncoder()
y_encoded = le.fit_transform(y)

# 缺失值填充
imputer = SimpleImputer(strategy="mean")
X_imputed = imputer.fit_transform(X)
```

### 分类模型

```python
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.neighbors import KNeighborsClassifier

models = {
    "lr": LogisticRegression(max_iter=1000),
    "rf": RandomForestClassifier(n_estimators=100, random_state=42),
    "gb": GradientBoostingClassifier(n_estimators=100, random_state=42),
    "svm": SVC(kernel="rbf", probability=True),
    "knn": KNeighborsClassifier(n_neighbors=5),
}

for name, model in models.items():
    model.fit(X_train, y_train)
    acc = model.score(X_test, y_test)
    print(f"{name}: {acc:.4f}")
```

### 回归模型

```python
from sklearn.linear_model import LinearRegression, Ridge, Lasso
from sklearn.ensemble import RandomForestRegressor, GradientBoostingRegressor

models = {
    "linear": LinearRegression(),
    "ridge": Ridge(alpha=1.0),
    "lasso": Lasso(alpha=0.1),
    "rf": RandomForestRegressor(n_estimators=100),
    "gb": GradientBoostingRegressor(n_estimators=100),
}
```

### 评估指标

```python
from sklearn.metrics import (
    accuracy_score, precision_score, recall_score, f1_score,
    confusion_matrix, classification_report, roc_auc_score,
    mean_squared_error, mean_absolute_error, r2_score,
)

# 分类
print(classification_report(y_test, y_pred))
confusion_matrix(y_test, y_pred)
roc_auc_score(y_test, y_proba[:, 1])

# 回归
mse = mean_squared_error(y_test, y_pred)
mae = mean_absolute_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)
```

### 交叉验证与调参

```python
from sklearn.model_selection import cross_val_score, GridSearchCV, RandomizedSearchCV

# 交叉验证
scores = cross_val_score(model, X, y, cv=5, scoring="accuracy")
print(f"CV: {scores.mean():.4f} ± {scores.std():.4f}")

# 网格搜索
param_grid = {
    "n_estimators": [50, 100, 200],
    "max_depth": [None, 10, 20],
    "min_samples_split": [2, 5, 10],
}
search = GridSearchCV(
    RandomForestClassifier(random_state=42),
    param_grid, cv=5, n_jobs=-1, verbose=1
)
search.fit(X_train, y_train)
print(f"Best params: {search.best_params_}")
print(f"Best score: {search.best_score_:.4f}")

# 随机搜索
search = RandomizedSearchCV(
    model, param_distributions, n_iter=50, cv=5, n_jobs=-1
)
```

### Pipeline

```python
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder

# 数值列预处理
numeric_transformer = Pipeline([
    ("imputer", SimpleImputer(strategy="median")),
    ("scaler", StandardScaler()),
])

# 类别列预处理
categorical_transformer = Pipeline([
    ("imputer", SimpleImputer(strategy="constant", fill_value="missing")),
    ("onehot", OneHotEncoder(handle_unknown="ignore")),
])

# 组合
preprocessor = ColumnTransformer([
    ("num", numeric_transformer, numeric_features),
    ("cat", categorical_transformer, categorical_features),
])

# 完整 Pipeline
pipeline = Pipeline([
    ("preprocessor", preprocessor),
    ("classifier", RandomForestClassifier()),
])

pipeline.fit(X_train, y_train)
```

### 特征工程

```python
from sklearn.feature_selection import SelectKBest, mutual_info_classif
from sklearn.decomposition import PCA

# 特征选择
selector = SelectKBest(mutual_info_classif, k=20)
X_selected = selector.fit_transform(X, y)

# PCA 降维
pca = PCA(n_components=0.95)  # 保留95%方差
X_pca = pca.fit_transform(X)

# 特征重要性
importances = model.feature_importances_
indices = np.argsort(importances)[::-1]
```

### 无监督学习

```python
from sklearn.cluster import KMeans, DBSCAN, AgglomerativeClustering
from sklearn.mixture import GaussianMixture

# K-Means
kmeans = KMeans(n_clusters=5, random_state=42)
labels = kmeans.fit_predict(X)
inertia = kmeans.inertia_  # 肘部法则用

# DBSCAN
dbscan = DBSCAN(eps=0.5, min_samples=5)
labels = dbscan.fit_predict(X)

# 高斯混合模型
gmm = GaussianMixture(n_components=5, random_state=42)
gmm.fit(X)
probs = gmm.predict_proba(X)  # 软聚类
```

---

## 4. 深度学习 (PyTorch)

### 张量基础

```python
import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim

# 创建张量
x = torch.tensor([[1, 2], [3, 4]], dtype=torch.float32)
x = torch.zeros(3, 4)
x = torch.ones(2, 3)
x = torch.randn(3, 3)       # 标准正态
x = torch.randint(0, 10, (3, 3))
x = torch.from_numpy(np_array)  # NumPy 转换

# 设备
device = torch.device("mps" if torch.backends.mps.is_available() else
                      "cuda" if torch.cuda.is_available() else "cpu")
x = x.to(device)

# 形状操作
x.view(batch, -1)    # 重塑
x.permute(0, 2, 1)   # 转置
x.unsqueeze(0)       # 增加维度
x.squeeze()          # 压缩维度
x.transpose(0, 1)    # 交换维度

# 自动求导
x = torch.randn(3, requires_grad=True)
y = x.pow(2).sum()
y.backward()
print(x.grad)  # 梯度
```

### 数据加载

```python
from torch.utils.data import Dataset, DataLoader, TensorDataset

# 自定义 Dataset
class MyDataset(Dataset):
    def __init__(self, X, y, transform=None):
        self.X = torch.tensor(X, dtype=torch.float32)
        self.y = torch.tensor(y, dtype=torch.long)
        self.transform = transform

    def __len__(self):
        return len(self.X)

    def __getitem__(self, idx):
        x = self.X[idx]
        if self.transform:
            x = self.transform(x)
        return x, self.y[idx]

# DataLoader
dataset = TensorDataset(X_tensor, y_tensor)
loader = DataLoader(dataset, batch_size=32, shuffle=True,
                    num_workers=4, pin_memory=True)

for batch_x, batch_y in loader:
    batch_x = batch_x.to(device)
    batch_y = batch_y.to(device)
    # 训练...
```

### 模型定义

```python
# 分类 MLP
class MLP(nn.Module):
    def __init__(self, input_dim, hidden_dim, num_classes):
        super().__init__()
        self.net = nn.Sequential(
            nn.Linear(input_dim, hidden_dim),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(hidden_dim, hidden_dim),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(hidden_dim, num_classes),
        )

    def forward(self, x):
        return self.net(x)

# CNN
class CNN(nn.Module):
    def __init__(self, num_classes=10):
        super().__init__()
        self.conv = nn.Sequential(
            nn.Conv2d(1, 32, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2),
            nn.Conv2d(32, 64, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2),
        )
        self.fc = nn.Sequential(
            nn.Linear(64 * 7 * 7, 128),
            nn.ReLU(),
            nn.Linear(128, num_classes),
        )

    def forward(self, x):
        x = self.conv(x)
        x = x.view(x.size(0), -1)
        return self.fc(x)

# RNN / LSTM
class LSTMClassifier(nn.Module):
    def __init__(self, vocab_size, embed_dim, hidden_dim, num_classes):
        super().__init__()
        self.embedding = nn.Embedding(vocab_size, embed_dim)
        self.lstm = nn.LSTM(embed_dim, hidden_dim, batch_first=True, bidirectional=True)
        self.fc = nn.Linear(hidden_dim * 2, num_classes)

    def forward(self, x):
        x = self.embedding(x)
        _, (hidden, _) = self.lstm(x)
        hidden = torch.cat((hidden[-2], hidden[-1]), dim=1)
        return self.fc(hidden)
```

### 训练循环

```python
def train_epoch(model, loader, criterion, optimizer, device):
    model.train()
    total_loss, correct, total = 0, 0, 0

    for batch_x, batch_y in loader:
        batch_x, batch_y = batch_x.to(device), batch_y.to(device)

        optimizer.zero_grad()
        outputs = model(batch_x)
        loss = criterion(outputs, batch_y)
        loss.backward()
        optimizer.step()

        total_loss += loss.item() * batch_x.size(0)
        _, predicted = outputs.max(1)
        total += batch_y.size(0)
        correct += predicted.eq(batch_y).sum().item()

    avg_loss = total_loss / total
    accuracy = correct / total
    return avg_loss, accuracy


def evaluate(model, loader, criterion, device):
    model.eval()
    total_loss, correct, total = 0, 0, 0

    with torch.no_grad():
        for batch_x, batch_y in loader:
            batch_x, batch_y = batch_x.to(device), batch_y.to(device)
            outputs = model(batch_x)
            loss = criterion(outputs, batch_y)

            total_loss += loss.item() * batch_x.size(0)
            _, predicted = outputs.max(1)
            total += batch_y.size(0)
            correct += predicted.eq(batch_y).sum().item()

    avg_loss = total_loss / total
    accuracy = correct / total
    return avg_loss, accuracy


# 完整训练流程
model = MLP(input_dim=784, hidden_dim=256, num_classes=10).to(device)
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=1e-3)
scheduler = optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max=100)

best_acc = 0.0
for epoch in range(100):
    train_loss, train_acc = train_epoch(model, train_loader, criterion, optimizer, device)
    val_loss, val_acc = evaluate(model, val_loader, criterion, device)
    scheduler.step()

    if val_acc > best_acc:
        best_acc = val_acc
        torch.save(model.state_dict(), "best_model.pt")

    print(f"Epoch {epoch:3d} | Train Loss: {train_loss:.4f} Acc: {train_acc:.4f} | Val Loss: {val_loss:.4f} Acc: {val_acc:.4f}")
```

### 优化器与学习率调度

```python
# 常用优化器
optim.SGD(model.parameters(), lr=0.01, momentum=0.9, weight_decay=1e-4)
optim.Adam(model.parameters(), lr=1e-3, weight_decay=1e-4)
optim.AdamW(model.parameters(), lr=1e-4, weight_decay=0.01)  # LLM 常用

# 学习率调度
scheduler = optim.lr_scheduler.StepLR(optimizer, step_size=30, gamma=0.1)
scheduler = optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max=100)
scheduler = optim.lr_scheduler.ReduceLROnPlateau(optimizer, mode="min", patience=5)
scheduler = optim.lr_scheduler.OneCycleLR(optimizer, max_lr=0.01, steps_per_epoch=len(loader), epochs=100)
```

### 损失函数

```python
nn.CrossEntropyLoss()        # 多分类
nn.BCEWithLogitsLoss()       # 二分类
nn.MSELoss()                 # 回归
nn.L1Loss()                  # MAE 回归
nn.CTCLoss()                 # 序列对齐 (OCR/ASR)
nn.KLDivLoss()               # KL 散度
nn.TripletMarginLoss()       # 对比学习
nn.CosineEmbeddingLoss()     # 相似度学习
```

### 迁移学习

```python
import torchvision.models as models

# 加载预训练模型
model = models.resnet50(pretrained=True)

# 冻结特征提取层
for param in model.parameters():
    param.requires_grad = False

# 替换分类头
model.fc = nn.Linear(2048, num_classes)

# 只训练新头
optimizer = optim.Adam(model.fc.parameters(), lr=1e-3)

# 解冻微调
for param in model.parameters():
    param.requires_grad = True
optimizer = optim.Adam(model.parameters(), lr=1e-5)
```

---

## 5. MLX (Apple Silicon)

MLX 是 Apple 专为 Apple Silicon 优化的机器学习框架。

```python
import mlx.core as mx
import mlx.nn as nn
import mlx.optimizers as optim

# 张量
x = mx.array([1, 2, 3])
y = mx.random.normal((3, 4))
z = mx.ones((2, 3))

# 自动求导
def loss_fn(w):
    return mx.mean((w * x - y) ** 2)

w = mx.random.normal((3,))
loss, grad = mx.value_and_grad(loss_fn)(w)

# 模型定义
class MLP(nn.Module):
    def __init__(self, input_dim, hidden_dim, num_classes):
        super().__init__()
        self.layers = [
            nn.Linear(input_dim, hidden_dim),
            nn.ReLU(),
            nn.Linear(hidden_dim, hidden_dim),
            nn.ReLU(),
            nn.Linear(hidden_dim, num_classes),
        ]

    def __call__(self, x):
        for layer in self.layers:
            x = layer(x)
        return x

# 训练循环
model = MLP(784, 256, 10)
optimizer = optim.Adam(learning_rate=1e-3)

def train_step(x, y):
    loss_fn = nn.CrossEntropyLoss()
    def loss_fn_model(w):
        return loss_fn(model(x), y)

    loss, grads = mx.value_and_grad(loss_fn_model)(model.parameters())
    optimizer.update(model, grads)
    return loss

for epoch in range(100):
    for batch_x, batch_y in train_loader:
        loss = train_step(batch_x, batch_y)
```

### MLX vs PyTorch 对比

| 特性 | PyTorch | MLX |
|------|---------|-----|
| 统一内存 | 需 `.to(device)` | 默认统一内存 |
| 框架大小 | ~400MB | ~10MB |
| MPS 加速 | 支持 (部分 ops) | 原生全支持 |
| 批处理 | DataLoader | 无内置，需手动 |
| 适用场景 | 通用深度学习 | LLM 推理/训练 |

---

## 6. Hugging Face Transformers

### 基础用法

```python
from transformers import (
    AutoTokenizer, AutoModel, AutoModelForCausalLM,
    pipeline, Trainer, TrainingArguments,
)

# Pipeline (最简接口)
classifier = pipeline("sentiment-analysis", model="distilbert-base-uncased")
result = classifier("I love this product!")
# [{'label': 'POSITIVE', 'score': 0.999}]

# 加载模型和分词器
tokenizer = AutoTokenizer.from_pretrained("bert-base-uncased")
model = AutoModel.from_pretrained("bert-base-uncased")

# 分词
inputs = tokenizer(
    "Hello, how are you?",
    return_tensors="pt",
    padding=True,
    truncation=True,
    max_length=512,
)

# 推理
with torch.no_grad():
    outputs = model(**inputs)
    last_hidden = outputs.last_hidden_state

# 文本生成
model = AutoModelForCausalLM.from_pretrained("gpt2")
tokenizer = AutoTokenizer.from_pretrained("gpt2")

inputs = tokenizer("Once upon a time", return_tensors="pt")
outputs = model.generate(
    inputs.input_ids,
    max_length=100,
    temperature=0.8,
    top_p=0.9,
    do_sample=True,
)
text = tokenizer.decode(outputs[0], skip_special_tokens=True)
```

### 微调

```python
from datasets import load_dataset, Dataset
from transformers import Trainer, TrainingArguments

# 加载数据集
dataset = load_dataset("imdb")

# 分词处理
def tokenize_fn(examples):
    return tokenizer(
        examples["text"],
        truncation=True,
        padding="max_length",
        max_length=512,
    )

dataset = dataset.map(tokenize_fn, batched=True)

# 训练参数
training_args = TrainingArguments(
    output_dir="./results",
    num_train_epochs=3,
    per_device_train_batch_size=16,
    per_device_eval_batch_size=32,
    learning_rate=2e-5,
    warmup_ratio=0.1,
    logging_steps=100,
    evaluation_strategy="epoch",
    save_strategy="epoch",
    load_best_model_at_end=True,
    report_to="tensorboard",
)

# Trainer
trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=dataset["train"],
    eval_dataset=dataset["test"],
    tokenizer=tokenizer,
)

trainer.train()
```

---

## 7. 计算机视觉

### TorchVision

```python
import torchvision
import torchvision.transforms as T
import torchvision.models as models
from torchvision.datasets import ImageFolder

# 数据增强
train_transform = T.Compose([
    T.RandomResizedCrop(224),
    T.RandomHorizontalFlip(),
    T.RandomRotation(15),
    T.ColorJitter(brightness=0.2, contrast=0.2),
    T.ToTensor(),
    T.Normalize(mean=[0.485, 0.456, 0.406],
                std=[0.229, 0.224, 0.225]),
])

val_transform = T.Compose([
    T.Resize(256),
    T.CenterCrop(224),
    T.ToTensor(),
    T.Normalize(mean=[0.485, 0.456, 0.406],
                std=[0.229, 0.224, 0.225]),
])

# 内置数据集
train_set = torchvision.datasets.CIFAR10(
    root="./data", train=True, download=True, transform=train_transform
)

# 自定义图片文件夹
dataset = ImageFolder(root="path/to/images", transform=train_transform)

# 预训练模型
model = models.resnet50(pretrained=True)
model = models.efficientnet_b0(pretrained=True)
model = models.vit_b_16(pretrained=True)  # Vision Transformer
```

### OpenCV

```python
import cv2

# 读写
img = cv2.imread("image.jpg")
cv2.imwrite("output.jpg", img)

# 预处理
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
resized = cv2.resize(img, (224, 224))
blurred = cv2.GaussianBlur(img, (5, 5), 0)
edges = cv2.Canny(img, 100, 200)

# 画图
cv2.rectangle(img, (x1, y1), (x2, y2), (0, 255, 0), 2)
cv2.circle(img, (cx, cy), r, (0, 0, 255), 2)
cv2.putText(img, "text", (x, y), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 2)
```

---

## 8. NLP 与 LLM

### 文本预处理

```python
import re
import jieba  # 中文分词

# 英文预处理
def clean_text(text):
    text = text.lower()
    text = re.sub(r"[^a-zA-Z0-9\s]", "", text)
    text = re.sub(r"\s+", " ", text).strip()
    return text

# 中文分词
text = "我爱机器学习和深度学习"
words = jieba.lcut(text)
# ['我', '爱', '机器学习', '和', '深度学习']
```

### LLM 推理

```python
# transformers
from transformers import AutoModelForCausalLM, AutoTokenizer

model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-3.1-8B-Instruct",
    torch_dtype=torch.bfloat16,
    device_map="auto",
)
tokenizer = AutoTokenizer.from_pretrained("meta-llama/Llama-3.1-8B-Instruct")

messages = [{"role": "user", "content": "解释什么是反向传播"}]
inputs = tokenizer.apply_chat_template(messages, return_tensors="pt").to(model.device)

outputs = model.generate(
    inputs,
    max_new_tokens=512,
    temperature=0.7,
    top_p=0.9,
    do_sample=True,
)
response = tokenizer.decode(outputs[0], skip_special_tokens=True)
```

### LoRA 微调

```python
from peft import LoraConfig, get_peft_model, TaskType

lora_config = LoraConfig(
    task_type=TaskType.CAUSAL_LM,
    r=8,                    # LoRA rank
    lora_alpha=32,
    lora_dropout=0.1,
    target_modules=["q_proj", "v_proj", "k_proj", "o_proj"],
)

model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-3.1-8B-Instruct",
    torch_dtype=torch.bfloat16,
    device_map="auto",
)
model = get_peft_model(model, lora_config)
model.print_trainable_parameters()
# 可训练参数: ~0.1% 的参数量
```

---

## 9. 训练优化

### 混合精度训练

```python
from torch.cuda.amp import autocast, GradScaler

scaler = GradScaler()

for batch_x, batch_y in loader:
    batch_x, batch_y = batch_x.to(device), batch_y.to(device)

    optimizer.zero_grad()

    with autocast(dtype=torch.bfloat16):  # bfloat16 更稳定
        outputs = model(batch_x)
        loss = criterion(outputs, batch_y)

    scaler.scale(loss).backward()
    scaler.step(optimizer)
    scaler.update()
```

### 梯度累积

```python
accumulation_steps = 4
optimizer.zero_grad()

for i, (batch_x, batch_y) in enumerate(loader):
    outputs = model(batch_x)
    loss = criterion(outputs, batch_y)
    loss = loss / accumulation_steps
    loss.backward()

    if (i + 1) % accumulation_steps == 0:
        optimizer.step()
        optimizer.zero_grad()
```

### 分布式训练

```python
# DDP (DistributedDataParallel)
import torch.distributed as dist
from torch.nn.parallel import DistributedDataParallel as DDP

dist.init_process_group(backend="nccl")
model = DDP(model, device_ids=[local_rank])

# FSDP (Fully Sharded Data Parallel)
from torch.distributed.fsdp import FullyShardedDataParallel as FSDP
from torch.distributed.fsdp import ShardingStrategy

model = FSDP(
    model,
    sharding_strategy=ShardingStrategy.SHARD_GRAD_OP,
    device_id=torch.cuda.current_device(),
)
```

### 模型量化

```python
# PyTorch 量化
import torch.quantization as quant

model.qconfig = quant.get_default_qconfig("fbgemm")
model_prepared = quant.prepare(model)
model_quantized = quant.convert(model_prepared)

# bitsandbytes 4-bit
from transformers import BitsAndBytesConfig

bnb_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_use_double_quant=True,
    bnb_4bit_compute_dtype=torch.bfloat16,
)

model = AutoModelForCausalLM.from_pretrained(
    "meta-llama/Llama-3.1-8B-Instruct",
    quantization_config=bnb_config,
    device_map="auto",
)
```

---

## 10. 实验管理

### TensorBoard

```python
from torch.utils.tensorboard import SummaryWriter

writer = SummaryWriter("runs/experiment_1")

# 记录标量
for epoch in range(100):
    writer.add_scalar("Loss/train", train_loss, epoch)
    writer.add_scalar("Loss/val", val_loss, epoch)
    writer.add_scalar("Acc/train", train_acc, epoch)
    writer.add_scalar("Acc/val", val_acc, epoch)

# 记录直方图
writer.add_histogram("weights", model.fc.weight, epoch)

# 记录模型图
writer.add_graph(model, dummy_input)

writer.close()

# 启动 TensorBoard
# tensorboard --logdir runs
```

### Weights & Biases

```python
import wandb

wandb.init(project="my-project", config={
    "learning_rate": 1e-3,
    "batch_size": 32,
    "epochs": 100,
    "model": "ResNet50",
})

for epoch in range(100):
    wandb.log({
        "train_loss": train_loss,
        "val_loss": val_loss,
        "train_acc": train_acc,
        "val_acc": val_acc,
        "learning_rate": optimizer.param_groups[0]["lr"],
    })

wandb.finish()
```

---

## 11. 部署

### ONNX 导出

```python
import torch.onnx

dummy_input = torch.randn(1, 3, 224, 224).to(device)
torch.onnx.export(
    model,
    dummy_input,
    "model.onnx",
    input_names=["input"],
    output_names=["output"],
    dynamic_axes={"input": {0: "batch_size"}, "output": {0: "batch_size"}},
)

# ONNX Runtime
import onnxruntime as ort

session = ort.InferenceSession("model.onnx")
outputs = session.run(None, {"input": numpy_input})
```

### TorchScript

```python
# Tracing
traced_model = torch.jit.trace(model, example_input)
traced_model.save("model.pt")

# Scripting
scripted_model = torch.jit.script(model)
scripted_model.save("model_script.pt")

# 加载
model = torch.jit.load("model.pt")
```

### Docker 部署

```dockerfile
FROM pytorch/pytorch:2.5-cuda12.4-cudnn9-runtime

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY model.pt .
COPY serve.py .

CMD ["python", "serve.py"]
```

---

## 12. 学习路线

### 阶段一：基础 (2-4 周)
- Python 数据科学 (NumPy/Pandas/Matplotlib)
- 线性代数、概率统计基础
- 机器学习基础概念

### 阶段二：机器学习 (4-6 周)
- Scikit-learn 全流程 (预处理→训练→评估→调参)
- 经典算法: 线性回归、SVM、决策树、随机森林
- Kaggle 入门竞赛 (Titanic/House Prices)

### 阶段三：深度学习 (6-8 周)
- PyTorch 张量/自动求导/训练循环
- CNN (图像分类/目标检测)
- RNN/LSTM/Transformer (序列建模)
- 迁移学习与微调

### 阶段四：进阶 (持续)
- LLM 微调 (LoRA/QLoRA)
- 多模态模型
- 模型部署 (ONNX/Triton)
- 分布式训练

### 推荐资源

| 资源 | 类型 | 适合阶段 |
|------|------|----------|
| 吴恩达《Machine Learning》| 课程 | 入门 |
| 李飞飞 CS231n (CNN) | 课程 | 进阶 |
| 李沐《动手学深度学习》| 书+代码 | 系统学习 |
| fast.ai Practical Deep Learning | 课程 | 实战 |
| Andrej Karpathy 博客 | 博客 | 进阶 |
| Papers With Code | 论文+代码 | 前沿追踪 |
| Hugging Face Course | 课程 | NLP/LLM |
| Kaggle | 竞赛 | 实战 |

---

> 本手册持续更新，欢迎补充和修正。
