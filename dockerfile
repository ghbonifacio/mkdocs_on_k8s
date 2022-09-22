FROM nginx:alpine
COPY projeto/site/ /usr/share/nginx/html/
EXPOSE 80