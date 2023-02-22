FROM ruby:3.1.3

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install --jobs 20 --retry 5

COPY entrypoint.sh /usr/bin/
RUN sed -i 's/\r$//' /usr/bin/entrypoint.sh \
    && chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"] 

# Copy the rest of the application code
COPY . .

# Expose the application port
EXPOSE 4000

# Run the Rails server
CMD ["rails", "server", "-b", "0.0.0.0", "-p", "4000"]
#CMD ["rm", "/app/tmp/pids/server.pid"]
