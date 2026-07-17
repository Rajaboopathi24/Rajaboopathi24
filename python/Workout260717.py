import pandas as pd
import statistics

#Reversestring
text = "abcdef"
print(text[::-1])

#DuplicateRemoval
number = [1,2,3,4,5,6,4,2,3,8]

unique = list[set(number)]
print(unique)

#Find the even Numbers

numbers = [1,2,3,4,5,6,4,2,3,8]

outputeven = []
outputodd = []
for n in numbers:
    if n % 2 == 0:
        outputeven.append(n)
    else:
        outputodd.append(n)

print (outputeven)
print (outputodd)


#count vowels

text = "NovacTech"
count = 0
vowels = "aeiou"

for ch in text:
    if ch in vowels:
        count += 1

print(count)


# Find the largest numbers

numbers = [1,2,3,4,5,6,4,2,3,8]
print("Maximum",max(numbers))
print("Minimum",min(numbers))
print("Average",statistics.mean(numbers))
print("Median",statistics.median(numbers))
print("Mode",statistics.mode(numbers))

#Frequency count
numbers = [1,2,3,4,5,6,4,2,3,8]

freq ={}
for ch in numbers:
    if ch in freq:
        freq[ch] += 1
    else:
        freq[ch] = 1    
print(freq)

#palindrome
text = "madam"
if text == text[::-1]:
    print("palindrome")
else:
    print("Not palindrome")

#Second largest
numbers = [1,2,3,4,5,6,4,2,3,8,13,37,33]
num = list(set(numbers))
num.sort()
print(num[-2])

#Merge two set
list1 = [1,2,3,4]
list2 = [4,5,6]

res = list1 + list2

print(res)

#Find the common elements
list1 = [1,2,3,4]
list2 = [4,5,6]

com = list(set(list1) & set(list2))
print(com)
