FROM clamav/clamav:stable_base AS base

# Install inotify-tools (Alpine package)
RUN apk add --no-cache inotify-tools

# Copy entrypoint script
COPY folder-watcher.sh /usr/local/bin/folder-watcher.sh
RUN chmod +x /usr/local/bin/folder-watcher.sh

ENTRYPOINT ["/usr/local/bin/folder-watcher.sh"]
