FROM ubuntu:xenial

ENV CC=musl-gcc \
    ZLIB_VER="1.2.11" \
    PREFIX=/musl \
    SSL_VER="1.0.2q" \
    PQ_VER="10.6" \
    LD_LIBRARY_PATH=$PREFIX \
    PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig

RUN apt-get update && apt-get install -y \
    vim musl-dev musl-tools make g++ curl pkgconf ca-certificates xutils-dev \
    libssl-dev libpq-dev automake autoconf libtool

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly && \
    ~/.cargo/bin/rustup target add x86_64-unknown-linux-musl && \
    echo "[build]\ntarget = \"x86_64-unknown-linux-musl\"" > ~/.cargo/config

RUN mkdir $PREFIX && cd ~

RUN curl -sSL http://zlib.net/zlib-$ZLIB_VER.tar.gz | tar xz && \
    cd zlib-$ZLIB_VER && \
    CC="musl-gcc -fPIC -pie" LDFLAGS="-L$PREFIX/lib" CFLAGS="-I$PREFIX/include" \
    ./configure --static --prefix=$PREFIX && \
    make -j$(nproc) && make install && \

RUN curl -sSL http://www.openssl.org/source/openssl-$SSL_VER.tar.gz | tar xz && \
    cd openssl-$SSL_VER && \
    ./Configure no-zlib no-shared -fPIC --prefix=$PREFIX --openssldir=$PREFIX/ssl linux-x86_64 && \
    env C_INCLUDE_PATH=$PREFIX/include make depend 2> /dev/null && \
    make -j$(nproc) && make install

RUN curl -sSL https://ftp.postgresql.org/pub/source/v$PQ_VER/postgresql-$PQ_VER.tar.gz | tar xz && \
    cd postgresql-$PQ_VER && \
    CC="musl-gcc -fPIE -pie" LDFLAGS="-L$PREFIX/lib" CFLAGS="-I$PREFIX/include" \
    ./configure --without-readline --prefix=$PREFIX --host=x86_64-unknown-linux-musl && \
    make -s -j$(nproc) && make -s install && \
    rm $PREFIX/lib/*.so && rm $PREFIX/lib/*.so.* && rm $PREFIX/lib/postgres* -rf

ENV PATH=$PREFIX/bin:$PATH \
    OPENSSL_DIR=$PREFIX \
    LIBZ_SYS_STATIC=1 \
    OPENSSL_STATIC=true \
    PG_CONFIG_X86_64_UNKNOWN_LINUX_GNU=/usr/bin/pg_config \
    PQ_LIB_STATIC_X86_64_UNKNOWN_LINUX_MUSL=true \
    PKG_CONFIG_ALL_STATIC=true
    # PKG_CONFIG_ALLOW_CROSS=true

WORKDIR /app