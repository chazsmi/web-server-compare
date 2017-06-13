FROM scratch
ADD goserver/server /
CMD [/server]
EXPOSE 8000
