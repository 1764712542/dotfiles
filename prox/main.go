package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/spf13/cobra"
)

const defaultPort = "7897"
const defaultHost = "127.0.0.1"

var presetPorts = []string{"7892", "7897", "1080", "3128", "8080"}

var (
	flagPort     string
	flagSocks5   bool
	flagHttp     bool
)

func main() {
	root := &cobra.Command{
		Use:   "prox",
		Short: "系统代理管理 CLI",
		Long: `管理系统代理环境变量，支持多端口切换和协议选择。

用法:
  eval "$(prox on)"              # 开启代理（默认 7892）
  eval "$(prox on -p 7897)"      # 指定端口
  eval "$(prox off)"             # 关闭代理
  prox status                    # 查看代理状态
  prox switch                    # 交互式选择端口`,
	}

	onCmd := &cobra.Command{
		Use:   "on",
		Short: "开启代理",
		Run: func(cmd *cobra.Command, args []string) {
			proxyURL := fmt.Sprintf("http://%s:%s", defaultHost, flagPort)
			allProxy := proxyURL
			if flagSocks5 {
				allProxy = fmt.Sprintf("socks5h://%s:%s", defaultHost, flagPort)
			}

			fmt.Printf("export HTTP_PROXY=%s\n", proxyURL)
			fmt.Printf("export HTTPS_PROXY=%s\n", proxyURL)
			fmt.Printf("export ALL_PROXY=%s\n", allProxy)
			fmt.Printf("export NO_PROXY=127.0.0.1,localhost,::1\n")
			fmt.Printf("export http_proxy=%s\n", proxyURL)
			fmt.Printf("export https_proxy=%s\n", proxyURL)
			fmt.Printf("export all_proxy=%s\n", allProxy)
			fmt.Printf("export no_proxy=127.0.0.1,localhost,::1\n")
			fmt.Fprintf(os.Stderr, "✓ 代理已开启 (%s)\n", proxyURL)
		},
	}
	onCmd.Flags().StringVarP(&flagPort, "port", "p", defaultPort, "代理端口")
	onCmd.Flags().BoolVarP(&flagSocks5, "socks5", "s", false, "使用 SOCKS5 协议")
	onCmd.Flags().BoolVarP(&flagHttp, "http", "", true, "使用 HTTP 协议")

	offCmd := &cobra.Command{
		Use:   "off",
		Short: "关闭代理",
		Run: func(cmd *cobra.Command, args []string) {
			vars := []string{
				"HTTP_PROXY", "HTTPS_PROXY", "ALL_PROXY", "NO_PROXY",
				"http_proxy", "https_proxy", "all_proxy", "no_proxy",
			}
			for _, v := range vars {
				fmt.Printf("unset %s\n", v)
			}
			fmt.Fprintln(os.Stderr, "✓ 代理已关闭")
		},
	}

	statusCmd := &cobra.Command{
		Use:   "status",
		Short: "查看代理状态",
		Run: func(cmd *cobra.Command, args []string) {
			httpsProxy := os.Getenv("HTTPS_PROXY")
			if httpsProxy == "" {
				httpsProxy = os.Getenv("https_proxy")
			}
			if httpsProxy != "" {
				fmt.Printf("代理状态: 开启 → %s\n", httpsProxy)
			} else {
				fmt.Println("代理状态: 关闭")
			}
		},
	}

	switchCmd := &cobra.Command{
		Use:   "switch",
		Short: "交互式选择端口",
		Long:  `列出预设端口，让用户选择并开启代理。使用: prox switch`,
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Fprintln(os.Stderr, "选择代理端口：")
			for i, p := range presetPorts {
				mark := ""
				if p == getCurrentPort() {
					mark = " ← 当前"
				}
				fmt.Fprintf(os.Stderr, "  %d. %s%s\n", i+1, p, mark)
			}

			var choice int
			fmt.Fprint(os.Stderr, "输入序号 (1-5): ")
			_, err := fmt.Scanf("%d", &choice)
			if err != nil || choice < 1 || choice > len(presetPorts) {
				fmt.Fprintln(os.Stderr, "✗ 无效选择")
				os.Exit(1)
			}

			selectedPort := presetPorts[choice-1]
			proxyURL := fmt.Sprintf("http://%s:%s", defaultHost, selectedPort)

			fmt.Printf("export HTTP_PROXY=%s\n", proxyURL)
			fmt.Printf("export HTTPS_PROXY=%s\n", proxyURL)
			fmt.Printf("export ALL_PROXY=%s\n", proxyURL)
			fmt.Printf("export NO_PROXY=127.0.0.1,localhost,::1\n")
			fmt.Printf("export http_proxy=%s\n", proxyURL)
			fmt.Printf("export https_proxy=%s\n", proxyURL)
			fmt.Printf("export all_proxy=%s\n", proxyURL)
			fmt.Printf("export no_proxy=127.0.0.1,localhost,::1\n")
			fmt.Fprintf(os.Stderr, "✓ 代理已切换至 %s\n", proxyURL)
		},
	}

	listCmd := &cobra.Command{
		Use:   "list",
		Short: "列出预设端口",
		Run: func(cmd *cobra.Command, args []string) {
			fmt.Println("预设端口：")
			for _, p := range presetPorts {
				mark := ""
				if p == getCurrentPort() {
					mark = " ← 当前"
				}
				fmt.Printf("  %s%s\n", p, mark)
			}
		},
	}

	root.AddCommand(onCmd, offCmd, statusCmd, switchCmd, listCmd)
	root.SetOut(os.Stdout)

	if err := root.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func getCurrentPort() string {
	for _, key := range []string{"HTTPS_PROXY", "https_proxy", "HTTP_PROXY", "http_proxy"} {
		val := os.Getenv(key)
		if val != "" {
			parts := strings.Split(val, ":")
			if len(parts) > 0 {
				return parts[len(parts)-1]
			}
		}
	}
	return ""
}
