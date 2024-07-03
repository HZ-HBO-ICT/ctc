import sys, os
import argparse
from dotenv import load_dotenv
import yaml
# Adding nice colors to the output
from colorama import just_fix_windows_console
from colorama import Fore, Style

verbosity = 0

def log(messages):
  last_level = 0
  last_msg = ""
  for level, msg in messages.items():
    if verbosity == level:
      print(msg)
    # remember this item as the last one
    last_level = level
    last_msg = msg
  # print if the verbosity is larger than the given level
  if verbosity > last_level:
    print(last_msg)


def check_renamed(path, filename, tofilename):
  full_name = os.path.join(path, filename)
  log({3: f"{Fore.MAGENTA}Full path of the original file: {Fore.WHITE}{full_name}{Style.RESET_ALL}"})
  full_name_to = os.path.join(path, tofilename)
  log({
    2: f"Check if the file is renamed to {tofilename}",
    3: f"{Fore.MAGENTA}Full path of the renamed file: {Fore.WHITE}{full_name_to}{Style.RESET_ALL}"
  })
  if os.path.exists(full_name) or not os.path.exists(full_name_to):
    log({
      0: f"One of the watermarks is NOT found",
      1: f"File NOT renamed [{filename}]",
      2: f"{Fore.RED}The file is NOT renamed{Style.RESET_ALL}"
    })
    # exit if there isn't any verbosity set
    if verbosity == 0:
      exit(1)
    # just return 0 in other verbosity levels
    return 0 
  # renaming was correct. Return 1
  log({
    1: f"Renamed {filename} to {tofilename}",
    2: f"{Fore.GREEN}{Style.BRIGHT}Watermark found{Style.NORMAL}. The file is renamed correctly{Style.RESET_ALL}"
  })
  return 1

def check_contains(path, filename, watermark):
  full_path = os.path.join(path, filename)
  log({3: f"{Fore.MAGENTA}Full path of the file to check: {Fore.WHITE}{full_path}{Style.RESET_ALL}"})
  # Exit if the file does not exist
  if not os.path.exists(full_path):
    log({
      0: "There is an error in the configuration or project",
      1: f"File NOT found [{full_path}]",
      2: f"{Fore.RED}The file is NOT found{Style.RESET_ALL}"
    })
    exit(1)
  log({3: f"{Fore.MAGENTA}The file is found{Style.RESET_ALL}"})
  log({2: f"{Fore.BLACK}Check if watermark {Fore.WHITE}{watermark} {Fore.BLACK}exists in the file{Style.RESET_ALL}"})
  with open(full_path, 'r') as f:
    if watermark in f.read():
      log({
        1: f"Found {watermark} in {full_path}",
        2: f"{Fore.GREEN}{Style.BRIGHT}Watermark found{Style.NORMAL}. The file contains the required text{Style.RESET_ALL}"
      })
      return 1
    else:
      log({
        0: f"One of the watermarks is NOT found!", 
        1: f"NOT found {watermark} in {full_path}",
        2: f"{Fore.RED}The required test is NOT found{Style.RESET_ALL}"
      })
      # exit if there isn't any verbosity set
      if verbosity == 0:
        exit(1)
      return 0
    

def init():
  # Initialize colorama
  just_fix_windows_console()
  # Load the .env file settings
  load_dotenv()
  # Initialize parser
  parser = argparse.ArgumentParser(description = "Check a Laravel project for watermarks")
  # Adding arguments
  parser.add_argument("file", 
                    help = "name of the yaml file")
  parser.add_argument("-v", "--verbosity", action="count", default=0, 
                    help="increase output verbosity")
  # Read arguments from command line
  args = parser.parse_args()
  global verbosity
  verbosity = args.verbosity
  log({})
  return args


if __name__ == '__main__':
  args = init()
  total = 0
  found = 0
  log({2: f"{Fore.BLACK}Opening configuration file {Fore.WHITE}{args.file}{Style.RESET_ALL}"})
  if not os.path.exists(args.file):
    exit(1)

  project_path = os.getenv("ProjectFolder", default="./")
  log({3: f"{Fore.MAGENTA}Project path is set to: {Fore.WHITE}{project_path}{Style.RESET_ALL}"})

  with open(args.file, "r") as file:
    for item in yaml.safe_load(file):
      total += 1
      log({3: f"{Fore.MAGENTA}Checking rule {total}: {Fore.WHITE}{item}{Style.RESET_ALL}"})
      if 'file' not in item:
        raise Exception("File key not found")
      log({2: f"{Fore.CYAN}Checking: {Fore.WHITE}{item['file']}{Style.RESET_ALL}"})        
      if 'renamedto' in item:
        found += check_renamed(project_path, item['file'], item['renamedto'])
      if 'contains' in item:
        found += check_contains(project_path, item['file'], item['contains'])
  # Log the result
  fore_color = Fore.GREEN if found==total else Fore.RED
  log({
    0: f"Found all watermarks",
    1: f"Found {found}/{total} watermarks",
    2: f"{fore_color}Found {Style.BRIGHT}{found}/{total}{Style.NORMAL} watermarks{Style.RESET_ALL}"
  })
  if found < total:
    log({1: f"{Fore.YELLOW}Exiting with exit code 1{Style.RESET_ALL}"})
    exit(1)
  log({3: f"{Fore.BLACK}Exiting with exit code 0{Style.RESET_ALL}"})

