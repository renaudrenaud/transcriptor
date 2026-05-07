FROM nginx:alpine
ARG VERSION=dev
RUN mkdir -p /var/www/version
RUN echo -n "${VERSION}" > /var/www/version/VERSION
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html config.json prompts.json /usr/share/nginx/html/
