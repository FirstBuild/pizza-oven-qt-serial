FROM kinsamanka/docker-qemu-chroot:jessie-base

RUN apt-get install -qq squashfs-tools

RUN proot -r /opt/rootfs -q qemu-arm-static apt-get update -y
RUN proot -r /opt/rootfs -q qemu-arm-static apt-get install -qq \
  g++ git make qt5-default libqt5serialport5-dev

ADD pizza-oven-qt-serial.pro /opt/rootfs/src/pizza-oven-qt-serial.pro
ADD serialportreader.h /opt/rootfs/src/serialportreader.h
ADD serialportreader.cpp /opt/rootfs/src/serialportreader.cpp
ADD main.cpp /opt/rootfs/src/main.cpp

RUN proot -r /opt/rootfs -q qemu-arm-static bash -c \
  "(cd /src && qmake -r && make check)"

RUN mkdir -p /opt/rootfs/package/usr/local/lib /opt/rootfs/package/usr/local/bin
RUN cp /opt/rootfs/src/pizza-oven-qt-serial /opt/rootfs/package/usr/local/bin

RUN proot -r /opt/rootfs -q qemu-arm-static bash -c \
  "ldd /src/pizza-oven-qt-serial | grep '/usr/lib' | cut -d' ' -f3 | xargs -I{} cp '{}' /package/usr/local/lib/" 

RUN mksquashfs /opt/rootfs/package pizza-oven-qt-serial.tcz

CMD ["cat", "pizza-oven-qt-serial.tcz"]
