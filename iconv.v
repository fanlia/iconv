
module iconv

#include <iconv.h>
#include <errno.h>

fn C.iconv_open(tocode &char, fromcode &char) C.iconv_t

fn C.iconv(cd C.iconv_t, inbuf &&char, inbytesleft &size_t, outbuf &&char, outbytesleft &size_t) size_t

fn C.iconv_close(cd C.iconv_t) int

pub struct Iconv {
pub:
	handle C.iconv_t
}

pub fn open(tocode string, fromcode string) Iconv {
	handle := C.iconv_open(&char(tocode.str), &char(fromcode.str))
	return Iconv { handle }
}

pub fn (cd &Iconv) close() {
	C.iconv_close(cd.handle)
}

pub fn (cd &Iconv) conv(inbuf []byte) []byte {
	mut results := []byte{}

	if inbuf.len == 0 {
		return results
	}

	mut outbuf := [512]byte{}
	mut inbytesleft := size_t(inbuf.len)

	for inbytesleft > size_t(0) {
		mut outbytesleft := size_t(outbuf.len)

		inptr := &inbuf[inbuf.len - int(inbytesleft)]
		outptr := unsafe { &outbuf[0] }

		res := C.iconv(cd.handle, &inptr, &inbytesleft, &outptr, &outbytesleft)

		if res == size_t(-1) && C.errno != C.E2BIG {
			panic("iconv: invalid input")
		}

		results << outbuf[0 .. outbuf.len - int(outbytesleft)]
	}

	return results
}

pub fn (cd &Iconv) conv_string(s string) string {
	out := cd.conv(s.bytes())
	if out.len == 0 { return '' }
	return string(out)
}

