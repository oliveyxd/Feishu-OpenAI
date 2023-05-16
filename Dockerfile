# Dockerfile reference,https://docs.docker.com/engine/reference/builder/

FROM golang:1.18 as golang
# FROM [--platform=<platform>] <image> [AS <name>]
# FROM [--platform=<platform>] <image>[:<tag>] [AS <name>]
# FROM [--platform=<platform>] <image>[@<digest>] [AS <name>]
# The FROM instruction initializes a new build stage and sets the Base Image for subsequent instructions.

ENV GO111MODULE=on \
    CGO_ENABLED=1 \
    GOPROXY=https://goproxy.cn,direct
# ENV <key>=<value> ...
# The ENV instruction sets the environment variable <key> to the value <value>.

WORKDIR /build
# WORKDIR /path/to/workdir
# The WORKDIR instruction sets the working directory for any RUN, CMD, ENTRYPOINT, COPY and ADD instructions that follow it in the Dockerfile. 
ADD /code /build
# ADD [--chown=<user>:<group>] [--chmod=<perms>] [--checksum=<checksum>] <src>... <dest>
# ADD [--chown=<user>:<group>] [--chmod=<perms>] ["<src>",... "<dest>"]
# The ADD instruction copies new files, directories or remote file URLs from <src> and adds them to the filesystem of the image at the path <dest>.

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags '-w -s' -o feishu_chatgpt
# RUN <command> (shell form, the command is run in a shell, which by default is /bin/sh -c on Linux or cmd /S /C on Windows)
# RUN ["executable", "param1", "param2"] (exec form)
# The RUN instruction will execute any commands in a new layer on top of the current image and commit the results. 

FROM alpine:latest

WORKDIR /app

RUN apk add --no-cache bash
COPY --from=golang /build/feishu_chatgpt /app
COPY --from=golang /build/role_list.yaml /app
# COPY [--chown=<user>:<group>] [--chmod=<perms>] <src>... <dest>
# COPY [--chown=<user>:<group>] [--chmod=<perms>] ["<src>",... "<dest>"]
# The COPY instruction copies new files or directories from <src> and adds them to the filesystem of the container at the path <dest>.
EXPOSE 9000
# EXPOSE <port> [<port>/<protocol>...]
# The EXPOSE instruction informs Docker that the container listens on the specified network ports at runtime. 
ENTRYPOINT ["/app/feishu_chatgpt"]
# ENTRYPOINT ["executable", "param1", "param2"]
# ENTRYPOINT command param1 param2
# An ENTRYPOINT allows you to configure a container that will run as an executable.