n=int(input())
print(min(map(int,input().split()),key=lambda x:(abs(x-0.1),-x))if n else 0)
