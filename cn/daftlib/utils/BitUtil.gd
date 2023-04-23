class_name BitUtil

# 获取value二进制下第n位（从右往左数，从1开始）的值（0或1）
static func getBitN(value, n):
	return (value >> (n - 1)) & 1

# 将value二进制下第n位设置为1，并返回设置后的值
static func setBitN1(value, n):
	return value | (1 << (n - 1))

# 将value二进制下第n位设置为0，并返回设置后的值
static func setBitN0(value, n):
	return value & ~(1 << (n - 1))

# 判断a和b的符号是否相反
static func oppositeSigns(a, b):
	return (a ^ b) < 0

# 判断value是否为奇数
static func isOdd(value):
	return (value & 1) == 1

# 计算value的绝对值
static func getAbs(value):
	return (value ^ (value >> 31)) - (value >> 31)

# 返回a和b中的最大值
static func getMax(a, b):
	return a ^ ((a ^ b) & -(1 if a < b else 0))

# 返回a和b中的最小值
static func getMin(a, b):
	return b ^ ((a ^ b) & -(1 if a < b else 0))

# 返回a和b的平均值，其中a和b必须为整数
static func average(a, b):
	return (a & b) + ((a ^ b) >> 1)

# 判断value是否为2的幂次方
static func isPower2(value):
	return ((value & (value - 1)) == 0) and (value != 0)

# 将value乘以2
static func mul2(value):
	return value << 1

# 将value除以2
static func div2(value):
	return value >> 1

# 返回value除以2的余数（0或1）
static func mod2(value):
	return value & 1

# 对value进行2的power次幂取模运算
static func mod2exp(value, power):
	return value & (2 ^ power - 1)

# 将value乘以2的power次幂
static func mul2exp(value, power):
	return value << power

# 将value除以2的power次幂
static func div2exp(value, power):
	return value >> power
