FROM lambci/lambda:build-ruby2.5 as dev
WORKDIR /app
COPY ./Gemfile* ./
RUN bundle
COPY . ./
