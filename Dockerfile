FROM bakerface/proot-armv7l-qtdeclarative:5.5.1

RUN apt-get install -qq squashfs-tools

ADD PizzaOvenUI /opt/rootfs/app

RUN proot -r /opt/rootfs -q qemu-arm-static bash -c \
  "(cd /app && /usr/local/qt5/bin/qmake -r && make check)"

RUN mkdir -p /opt/rootfs/package/usr/local/lib/pizza-oven-touchscreen \
             /opt/rootfs/package/usr/local/bin

RUN cp /opt/rootfs/app/PizzaOvenUI /opt/rootfs/package/usr/local/lib/pizza-oven-touchscreen/pizza-oven-touchscreen

RUN proot -r /opt/rootfs -q qemu-arm-static bash -c \
  "ldd /app/PizzaOvenUI | grep '/usr/lib' | cut -d' ' -f3 | xargs -I{} cp '{}' /package/usr/local/lib/pizza-oven-touchscreen"

RUN echo '#!/bin/sh' > /opt/rootfs/package/usr/local/bin/pizza-oven-touchscreen
RUN echo 'cd /usr/local/lib/pizza-oven-touchscreen && LD_LIBRARY_PATH="./" pizza-oven-touchscreen' >> /opt/rootfs/package/usr/local/bin/pizza-oven-touchscreen
RUN chmod +x /opt/rootfs/package/usr/local/bin/pizza-oven-touchscreen

RUN mksquashfs /opt/rootfs/package pizza-oven-touchscreen.tcz

CMD ["cat", "pizza-oven-touchscreen.tcz"]
