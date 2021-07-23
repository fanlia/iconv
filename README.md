# iconv
iconv for vlang

## Getting Started

```sh
v install fanlia.iconv
```

## Usage

```v
import fanlia.iconv

fn main() {

	cd := iconv.open('gbk', 'utf-8')

	defer { cd.close() }

	gbk := cd.conv_string('你好')

	println(gbk)

}

```

## License

MIT
