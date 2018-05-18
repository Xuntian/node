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