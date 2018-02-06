from random import randint
from random import seed
from random import choice
import operator
seed()

code_range_min = 0
code_range_max = 26

folder = []

avg_code_numbers = {}

num_draft_drops =2

num_folder_chips = 30


num_iters = 10000

asterisk_code = 26

possible_codes = [
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  26

]

for it in range(num_iters):

  code_numbers = {}
  sorted_code_numbers = []
  for chip_idx in range(num_folder_chips):
    
    # Roll random drops
    random_drops = []
    
    for drop_idx in range(num_draft_drops):
      random_drops.append(choice(possible_codes))
      
    
    picked_code = 0
    
    
    # Check if we can find our best code
    found_code = 0
    sorted_code_numbers = sorted(code_numbers, key=code_numbers.get, reverse=True)
    for code in sorted_code_numbers:
 
      for drop_idx in range(num_draft_drops):
      
        if random_drops[drop_idx] == asterisk_code:
           picked_code = asterisk_code
           found_code = 1
           break
           
      if found_code == 1:
        break   
        
      for drop_idx in range(num_draft_drops):
      
        if random_drops[drop_idx] == code:
          picked_code = code
          found_code = 1
          break
      
          
      if found_code == 1:
        break
      
    if found_code == 0:
        # Pick randomly:
        picked_code = random_drops[randint(0, num_draft_drops - 1)]
      
      
    
    folder.append(picked_code)
    
    if picked_code in code_numbers:
      code_numbers[picked_code] = code_numbers[picked_code] + 1
    else:
      code_numbers[picked_code] = 1

      
  sorted_code_numbers = sorted(code_numbers, key=code_numbers.get, reverse=True)

  avg_code_numbers_it = 0
  for key in sorted_code_numbers:
  
    if key != asterisk_code:
    
      if avg_code_numbers_it in avg_code_numbers:
        avg_code_numbers[avg_code_numbers_it] = avg_code_numbers[avg_code_numbers_it] + code_numbers[key]
      else:
        avg_code_numbers[avg_code_numbers_it] = code_numbers[key]
      
      
      avg_code_numbers_it = avg_code_numbers_it + 1
    else:
    
      if 'Asterisk' in avg_code_numbers:
        avg_code_numbers['Asterisk'] = avg_code_numbers['Asterisk'] + code_numbers[key]
      else:
        avg_code_numbers['Asterisk'] = code_numbers[key]
      
    
 
for key in avg_code_numbers:

  print("CODE: ", key, " NUMBER: ", avg_code_numbers[key] * 1.0 / num_iters)
  
  