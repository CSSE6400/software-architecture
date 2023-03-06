# Packaging software example

## my pc
docker run --rm -it python-working
# ./program.py

## richards pc
docker run --rm -it python-nopython
# ./program.py

docker run --rm -it python-python3.5
# ./program.py

docker run --rm -it python-python3.6
# ./program.py
# pip install numpy
# ./program.py



# Chroot example

docker run --rm -it chroot-demo

# mkdir ./jail
# cd jail
# mkdir bin
# cp /bin/ls bin
# chrot . /bin/ls

# ldd /bin/ls
# cp --parents /lib/x86_64-linux-gnu/libselinux.so.1 /lib/x86_64-linux-gnu/libc.so.6 /lib/x86_64-linux-gnu/libpcre2-8.so.0 /lib64/ld-linux-x86-64.so.2 .
# ls
# ls lib/x86_64-linux-gnu

# chroot . /bin/ls
# chroot . /bin/ls /
# chroot . /bin/ls ..
# chroot . /bin/ls /bin


# Layered example

docker run --rm -it --privileged layered-demo

