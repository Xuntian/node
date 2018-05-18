# node
Node项目的开发运维实例

## Node项目的构建发布流程
1. 准备构建基础环境
2. 处理依赖
3. 编译 
4. 构建docker镜像
5. 运行docker镜像，暴露访问端点
6. 配置nginx虚拟主机和访问域名

## 准备构建基础环境
将docker用于项目的构建和发布是很方便快捷的做法，首先我们需要准备用于构建发布的docker镜像作为基础环境；
此处由于是node项目，所有需要node,npm,yarn等环境；
官方镜像node:10 中已经安装好node-10.1/npm-5.6/yarn-1.6环境，则建议使用该镜像作为构建的基础镜像；
注意：使用的任何docker镜像最好都带上容易识别的tag标签，已区分各个镜像的工具版本，这也是使用docker的优势之一；
```
docker build -t xuntian/node:10.1-npm-5.6-yarn-1.6 -f env.dockerfile ./

cat env.dockerfile

FROM node:10
MAINTAINER xuntian li.zq@foxmail.com
# 创建构建工作目录
RUN mkdir /code
WORKDIR /code
```

## 处理依赖
构建node项目需要运行npm/yarn install 以安装依赖，为了充分利用上一次构建的依赖包，我们将每次安装依赖的结果即node_module目录放到当前项目目录下
```
docker run --rm -v {project_path}:/code xuntian/node:10.1-npm-5.6-yarn-1.6 npm install 
```
上面的命令只是借助node的docker镜像在容器内部安装和编译依赖，并将下载编译的依赖包通过volume的方式挂载在容器外部

## 编译 && 构建docker镜像
编辑build.dockerfile文件用于node项目的编译和docker镜像的构建
```
FROM xuntian/node:10.1-npm-5.6-yarn-1.6 as builder
MAINTAINER xuntian li.zq@foxmail.com

COPY ./ /code/
WORKDIR /code
ARG NODE_ENV
ARG KEEPWORK_LOCALE
RUN npm build

FROM nginx
WORKDIR /usr/share/nginx/html
COPY --from=builder /code/dist .
CMD ["nginx", "-g", "daemon off;"]
```

