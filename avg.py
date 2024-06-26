a = (int(input("Enter First Values: " )))
b = (int(input("Enter Second Values: " )))
c = (int(input("Enter Third Values: " )))

def avg(a , b, c):
    avg = (a + b + c) / 3
    print(avg)
    return avg

print("Average of ", a,",",b,",",c, "is") 
avg(a,b,c)
