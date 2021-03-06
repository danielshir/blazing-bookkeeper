#!/bin/bash
set -e

mkdir -p $BUILDDIR
DEST_DEPENDENCIES_DIR=$THIRDPARTYDIR/dependencies

# Compile jpeg
cd $BUILDDIR
if [ ! -d "$BUILDDIR/jpeg-src" ]
then
  if [ ! -f "$BUILDDIR/jpegsrc.v9b.tar.gz" ]
  then
    curl -o jpegsrc.v9b.tar.gz -L -z jpegsrc.v9b.tar.gz http://www.ijg.org/files/jpegsrc.v9b.tar.gz
  fi
  tar xzf jpegsrc.v9b.tar.gz
  mv jpeg-9b jpeg-src
fi
if [ ! -f "$DEST_DEPENDENCIES_DIR/lib/libjpeg.dylib" ]
then
  cd jpeg-src
  ./configure \
    --prefix=$DEST_DEPENDENCIES_DIR \
    --disable-dependency-tracking
  make install
fi

# Compile libpng
cd $BUILDDIR
if [ ! -d "$BUILDDIR/libpng-src" ]
then
  if [ ! -f "$BUILDDIR/libpng-1.6.32.tar.xz" ]
  then
    curl -o libpng-1.6.32.tar.xz -L -z libpng-1.6.32.tar.xz ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng16/libpng-1.6.32.tar.xz
  fi
  tar xzf libpng-1.6.32.tar.xz
  mv libpng-1.6.32 libpng-src
fi
if [ ! -f "$DEST_DEPENDENCIES_DIR/lib/libpng.dylib" ]
then
  cd libpng-src
  ./configure \
    --prefix=$DEST_DEPENDENCIES_DIR \
    --disable-dependency-tracking
  make
  make install
fi

# Compile libtiff
cd $BUILDDIR
if [ ! -d "$BUILDDIR/tiff-src" ]
then
  if [ ! -f "$BUILDDIR/tiff-4.0.8.tar.gz" ]
  then
    curl -o tiff-4.0.8.tar.gz -L -z tiff-4.0.8.tar.gz http://download.osgeo.org/libtiff/tiff-4.0.8.tar.gz
  fi
  tar xzf tiff-4.0.8.tar.gz
  mv tiff-4.0.8 tiff-src
fi
if [ ! -f "$DEST_DEPENDENCIES_DIR/lib/libtiff.dylib" ]
then
  cd tiff-src
  ./configure \
    --prefix=$DEST_DEPENDENCIES_DIR \
    --disable-dependency-tracking \
    --without-x \
    --with-jpeg-include-dir=$DEST_DEPENDENCIES_DIR/include \
    --with-jpeg-lib-dir=$DEST_DEPENDENCIES_DIR/lib \
    --disable-lzma \
    --disable-docs
  make
  make install
fi

# Compile leptonica
cd $BUILDDIR
if [ ! -d "$BUILDDIR/leptonica-src" ]
then
  if [ ! -f "$BUILDDIR/leptonica-1.74.4.tar.gz" ]
  then
    curl -o leptonica-1.74.4.tar.gz -L -z leptonica-1.74.4.tar.gz https://github.com/DanBloomberg/leptonica/releases/download/1.74.4/leptonica-1.74.4.tar.gz
  fi
  tar xzf leptonica-1.74.4.tar.gz
  mv leptonica-1.74.4 leptonica-src
fi
if [ ! -f "$DEST_DEPENDENCIES_DIR/lib/liblept.dylib" ]
then
  cd leptonica-src
  chmod +x configure
  ./configure \
    --prefix=$DEST_DEPENDENCIES_DIR \
    --exec-prefix=$DEST_DEPENDENCIES_DIR \
    --disable-dependency-tracking \
    --without-libwebp \
    --without-giflib \
    --without-libopenjpeg \
    --disable-static \
    --disable-programs
  chmod +x config/install-sh
  make install-strip
fi

# Compile freetype
cd $BUILDDIR
if [ ! -d "$BUILDDIR/freetype-src" ]
then
  if [ ! -f "$BUILDDIR/freetype-2.8.tar.gz" ]
  then
    curl -o freetype-2.8.tar.gz -L -z freetype-2.8.tar.gz https://downloads.sourceforge.net/project/freetype/freetype2/2.8/freetype-2.8.tar.gz
  fi
  tar xzf freetype-2.8.tar.gz
  mv freetype-2.8 freetype-src
fi
if [ ! -f "$DEST_DEPENDENCIES_DIR/lib/libfreetype.dylib" ]
then
  cd freetype-src
  chmod +x configure
  ./configure \
    --prefix=$DEST_DEPENDENCIES_DIR \
    --without-harfbuzz
  make
  make install
fi

# Compile fontconfig
cd $BUILDDIR
if [ ! -d "$BUILDDIR/fontconfig-src" ]
then
  if [ ! -f "$BUILDDIR/fontconfig-2.12.5.tar.gz" ]
  then
    curl -o fontconfig-2.12.5.tar.gz -L -z fontconfig-2.12.5.tar.gz https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.5.tar.gz
  fi
  tar xzf fontconfig-2.12.5.tar.gz
  mv fontconfig-2.12.5 fontconfig-src
fi
if [ ! -f "$DEST_DEPENDENCIES_DIR/lib/libfontconfig.dylib" ]
then
  cd fontconfig-src
  chmod +x configure
  ./configure \
    --prefix=$DEST_DEPENDENCIES_DIR \
    --localstatedir=$DEST_DEPENDENCIES_DIR/var \
    --sysconfdir=$DEST_DEPENDENCIES_DIR/etc \
    --disable-dependency-tracking \
    --with-add-fonts=/System/Library/Fonts,/Library/Fonts,~/Library/Fonts \
    --disable-docs

  make install RUN_FC_CACHE_TEST=false
fi

# Little CMS 2
cd $BUILDDIR
if [ ! -d "$BUILDDIR/lcms2-src" ]
then
  if [ ! -f "$BUILDDIR/lcms2-2.8.tar.gz" ]
  then
    curl -o lcms2-2.8.tar.gz -L -z lcms2-2.8.tar.gz https://downloads.sourceforge.net/project/lcms/lcms/2.8/lcms2-2.8.tar.gz
  fi
  tar xzf lcms2-2.8.tar.gz
  mv lcms2-2.8 lcms2-src
fi
if [ ! -f "$DEST_DEPENDENCIES_DIR/lib/liblcms2.dylib" ]
then
  cd lcms2-src
  ./configure \
    --prefix=$DEST_DEPENDENCIES_DIR \
    --disable-dependency-tracking \
    --with-tiff=$DEST_DEPENDENCIES_DIR/lib \
    --with-jpeg=$DEST_DEPENDENCIES_DIR/lib
  make install
fi
