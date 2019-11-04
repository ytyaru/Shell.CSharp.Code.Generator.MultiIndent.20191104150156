# stdin: インデントしたいテキスト  $1: インデント用文字列（任意。省略時はタブ）
indent() { echo "$(cat -)" | sed "s/^/${1:-\t}/g"; }
# $1..9..{10}.. 位置引数の位置がそのままインデント階層である
indent_pos() {
	local result=""
	local indent=0
	# $1: 繰り返したいテキスト（省略時""）  $2: 回数（省略時1）
	repeat() {
		local target=${1:-}; local count=${2:-2}; let count--;
		[ 0 -lt $count ] && printf "$target"'%*s' $count;
	}
	# ソフトインデントを返す。$1: インデント数(省略時0) $2: 1インデントあたりのスペース数(省略時4)  
	soft_indent() { repeat ' ' $((${1:-0} * ${2:-4})); }
	# $1を$2だけインデントする
	indent_part() {
		local indent=${2:-0}
		[ 0 -eq $indent ] && echo "$1" || \
			echo "$1" | indent "$(soft_indent $indent)";
	}
	for code in "$@"; do
		result+="$(indent_part "$code" $indent)""\n"
		let indent++
	done
	echo -e "$result" | head -c -1
}
