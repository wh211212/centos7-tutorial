# FFmpeg

- 一个完整的跨平台解决方案，用于记录，转换和流式传输音频和视频。

- 文档：https://www.ffmpeg.org/documentation.html

ffmpeg -i input.mp4 output.avi


## FFmpeg安装

- CentOS7 

```
sudo rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
```

sudo yum install ffmpeg ffmpeg-devel -y

ffmpeg -h