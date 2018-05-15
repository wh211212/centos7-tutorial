# FFmpeg

- 一个完整的跨平台解决方案，用于记录，转换和流式传输音频和视频。

- 文档：https://www.ffmpeg.org/documentation.html

## FFmpeg安装

- CentOS7 

```
sudo rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
```

- CentOS6

```
sudo rpm --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el6/x86_64/nux-dextop-release-0-2.el6.nux.noarch.rpm
```

- 安装

```
sudo yum install ffmpeg ffmpeg-devel -y
# 查看帮助
ffmpeg -h
ffmpeg -i input.mp4 output.avi
```

## CentOS6安装FFmpeg最新版

- 参考：https://trac.ffmpeg.org/wiki/CompilationGuide/Centos

### 在CentOS上编译FFmpeg

- 安装依赖包

```
# 必须要安装的依赖包
yum install autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ git libtool make mercurial pkgconfig zlib-devel cmake hg numactl numactl-devel freetype freetype-devel freetype-demos
```

- 在主目录下创建一个新目录，将所有源代码放入：

```
# mkdir ~/ffmpeg_sources
```

### 编译和安装

- 编译安装前卸载直接yum安装的FFmpeg

```
yum remove ffmpeg ffmpeg-devel nasm -y
```

- 安装NSAM

```
cd ~/ffmpeg_sources
curl -O -L http://www.nasm.us/pub/nasm/releasebuilds/2.13.02/nasm-2.13.02.tar.bz2
tar xjvf nasm-2.13.02.tar.bz2
cd nasm-2.13.02
./autogen.sh
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install
```

- 安装Yasm

```
cd ~/ffmpeg_sources
curl -O -L http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin"
make
make install
```

- 安装libx264

```
cd ~/ffmpeg_sources
git clone --depth 1 http://git.videolan.org/git/x264
cd x264
PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static
make
make install
```

- 安装libx265

```
cd ~/ffmpeg_sources
hg clone https://bitbucket.org/multicoreware/x265
cd ~/ffmpeg_sources/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
make
make install
```

- 安装libfdk_aac

```
cd ~/ffmpeg_sources
git clone --depth 1 https://github.com/mstorsjo/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
```

- 安装libmp3lame

```
cd ~/ffmpeg_sources
curl -O -L http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
tar xzvf lame-3.100.tar.gz
cd lame-3.100
./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --disable-shared --enable-nasm
make
make install
```

- libopus

```
cd ~/ffmpeg_sources
curl -O -L https://archive.mozilla.org/pub/opus/opus-1.2.1.tar.gz
tar xzvf opus-1.2.1.tar.gz
cd opus-1.2.1
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
```

- 安装libogg

```
cd ~/ffmpeg_sources
curl -O -L http://downloads.xiph.org/releases/ogg/libogg-1.3.3.tar.gz
tar xzvf libogg-1.3.3.tar.gz
cd libogg-1.3.3
./configure --prefix="$HOME/ffmpeg_build" --disable-shared
make
make install
```

- 安装libvorbis

```
cd ~/ffmpeg_sources
curl -O -L http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.gz
tar xzvf libvorbis-1.3.5.tar.gz
cd libvorbis-1.3.5
./configure --prefix="$HOME/ffmpeg_build" --with-ogg="$HOME/ffmpeg_build" --disable-shared
make
make install
```

- 安装libvpx

```
# 这里坑了笔者两个多小时，笔者直接克隆的github上源码。configure过不去，一直报错，解决如下：
cd ~/ffmpeg_sources
wget https://github.com/webmproject/libvpx/archive/v1.7.0.tar.gz
tar zxvf v1.7.0.tar.gz
mv libvpx-1.7.0 libvpx
cd libvpx
./configure --prefix="$HOME/ffmpeg_build" --with-ogg="$HOME/ffmpeg_build" --disable-shared  #终于过去，高兴坏了
make
make install
```

- 安装FFmpeg 

```
cd ~/ffmpeg_sources
curl -O -L https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-libs=-lpthread \
  --extra-libs=-lm \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-libfdk_aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree
make
make install
hash -r
```

> 现在编译完成，ffmpeg（也是ffprobe，ffserver，lame和x264）现在应该可以使用了。




