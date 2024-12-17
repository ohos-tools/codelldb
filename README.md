# CodeLLDB for OHOS

本仓库是 [CodeLLDB](https://github.com/vadimcn/codelldb.git) 的 fork，原拓展的说明参见：[README](README_CODELLDB.md) 。

## 1. 构建

### 1.1. Windows

1. 通过 Visual Studio 安装 c++ 编译器

1. 仓库路径执行

    ```
    cmake -S . -B build
    cmake --build build
    ```

## 2. 构建缓存

下面介绍本项目支持的各种构建缓存机制。本节末尾给了一个 CMakePreset.json 示例，包括所有需要的配置。

## 2.1. vcpkg 缓存

vcpkg 自带缓存功能。其中 asset cache 是保存下载内容的，binary cache 是保存编译结果的，可以通过环境变量控制缓存的位置。例如：

```
set X_VCPKG_ASSET_SOURCES=clear;x-azurl,file://E:/caches/asset,,readwrite
set VCPKG_BINARY_SOURCES=clear;files,E:\caches\binary,readwrite
```

缓存 E:/caches/asset 和 E:\caches\binary 可以共享。

## 2.2. ccache 缓存

此外，还支持用 ccache 缓存编译命令的中间产物，方法如下：

1. 安装 ccache

2. 设置环境变量 CCACHE_PATH 到 ccache.exe 的 **完整路径** （相对路径不起作用）

3. 用下面的命令执行 ccache 构建。

```
cmake -S . -B build -DVCPKG_TARGET_TRIPLET=x64-windows-fast -DVCPKG_HOST_TRIPLET=x64-windows-fast
```

特殊的 triplet “x64-windows-fast” 是用来配置 ccahe 的。

## 2.3. CMakePresets.json 示例

下面是将上述缓存配置好的一个 CMakePresets.json 示例。可以用 `cmake --preset default` 执行。注意将路径替换成本地路径。

```json
{
    "version": 2,
    "cmakeMinimumRequired": {
        "major": 3,
        "minor": 19,
        "patch": 0
    },
    "configurePresets": [
        {
            "name": "default",
            "hidden": false,
            "description": "Default preset",
            "generator": "Visual Studio 16 2019",
            "binaryDir": "${sourceDir}/build",
            "cacheVariables": {
                "VCPKG_TARGET_TRIPLET": "x64-windows-fast",
                "VCPKG_HOST_TRIPLET": "x64-windows-fast"
            },
            "environment": {
                "X_VCPKG_ASSET_SOURCES": "clear;x-azurl,file://E:/caches/asset,,readwrite",
                "VCPKG_BINARY_SOURCES": "clear;files,E:\\caches\\binary,readwrite",
                "CCACHE_PATH": "D:\\bin\\ccache\\ccache.exe",
                "VCPKG_MAX_CONCURRENCY": "16"
            }
        }
    ],
    "buildPresets": [
        {
            "name": "default",
            "configurePreset": "default",
            "description": "Default build preset"
        }
    ]
}

```
