LOCAL_PATH := $(call my-dir)

CORE_DIR       := $(LOCAL_PATH)/../..
TREMOR_SRC_DIR := $(CORE_DIR)/core/tremor

SOURCES_C  :=
WANT_CRC32 := 1
HAVE_CHD   := 1

include $(CORE_DIR)/libretro/Makefile.common

COREFLAGS := -ffast-math -funroll-loops -DINLINE="static inline" -DUSE_LIBTREMOR -DUSE_16BPP_RENDERING -DLSB_FIRST -DBYTE_ORDER=LITTLE_ENDIAN -D__LIBRETRO__ -DFRONTEND_SUPPORTS_RGB565 -DALIGN_LONG -DALIGN_WORD -DM68K_OVERCLOCK_SHIFT=20 -DZ80_OVERCLOCK_SHIFT=20 -DHAVE_YM3438_CORE -DUSE_LIBCHDR -DPACKAGE_VERSION=\"1.3.2\" -DFLAC_API_EXPORTS -DFLAC__HAS_OGG=0 -DHAVE_LROUND -DHAVE_STDINT_H -D_7ZIP_ST -DHAVE_SYS_PARAM_H $(INCFLAGS)

ifeq ($(TARGET_ARCH),arm)
  COREFLAGS += -D_ARM_ASSEM_
endif

GIT_VERSION := " $(shell git rev-parse --short HEAD || echo unknown)"
ifneq ($(GIT_VERSION)," unknown")
  COREFLAGS += -DGIT_VERSION=\"$(GIT_VERSION)\"
endif

include $(CLEAR_VARS)
LOCAL_MODULE    := retro
LOCAL_SRC_FILES := $(SOURCES_C)
LOCAL_CFLAGS    := $(COREFLAGS)
LOCAL_LDFLAGS   := -Wl,-version-script=$(LIBRETRO_DIR)/link.T
LOCAL_ARM_MODE  := arm
include $(BUILD_SHARED_LIBRARY)
