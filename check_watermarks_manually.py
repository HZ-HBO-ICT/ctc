import check_watermarks as base
from dotenv import load_dotenv
import traceback
import os
# Adding nice colors to the output
from colorama import just_fix_windows_console
from colorama import Fore, Style

# The global verbosity level
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
  if verbosity > last_level and last_msg!="":
    print(last_msg)


def logException(e, message="There is something wrong"):
  log({
    0: message,
    1: repr(e),
    2: f"{Fore.RED}{Style.BRIGHT}EXCEPTION{Style.NORMAL} {repr(e)}{Style.RESET_ALL}",
    3: f"{Fore.RED}{Style.BRIGHT}EXCEPTION{Style.NORMAL} {traceback.format_exc()}{Style.RESET_ALL}"
  })


def logRuleConfigurationError(e):
  logException(e, message="There is something wrong with the configuration and/or project files")  


def logWatermarkException(e):
  logException(e, message="One of the watermarks is NOT found")


def logresult(found, total):
  log({
    3: f"{Fore.BLACK}Outputting result{Style.RESET_ALL}"
  })
  lvl0_message = "Found all watermarks"
  lvl2_fore_color = Fore.GREEN 
  exitcode = 0
  exit_color = Fore.BLACK
  if found!=total:
    lvl0_message = "Did not found all of the watermarks"
    lvl2_fore_color = Fore.RED
    exitcode = 1
    exit_color = Fore.YELLOW
  log({
    0: lvl0_message,
    1: f"Found {found}/{total} watermarks",
    2: f"{lvl2_fore_color}Found {Style.BRIGHT}{found}/{total}{Style.NORMAL} watermarks{Style.RESET_ALL}"
  })
  log({
    3: f"{exit_color}Exiting with exit code 0{Style.RESET_ALL}"
  })


def init_verbose():
  parser = base.init_argparser()
  parser.add_argument("-v", "--verbosity", action="count", default=0, 
                help="increase output verbosity")
  args = parser.parse_args()
  global verbosity
  verbosity = args.verbosity
  log({
    3: f"{Fore.YELLOW}Output verbosity level is set to: {args.verbosity} {Style.RESET_ALL}"
  })
  return args


def load_env_verbose():
  log({
    3: f"{Fore.BLACK}Loading environment settings from .env{Style.RESET_ALL}"
  })
  load_dotenv()

  log({
    3: f"{Fore.BLACK}Fetching the project path{Style.RESET_ALL}"
  })
  project_path = os.getenv("ProjectFolder", default="./")
  log({
    3: f"{Fore.BLACK}Project path set to: {Style.RESET_ALL}{project_path}"
  })
  return project_path


def getrules_verbose(file):
  log({
    3: f"{Fore.BLACK}Loading watermark rules from {Fore.WHITE}{Style.BRIGHT}{file}{Style.RESET_ALL}"
  })
  rules = base.getrules(file)
  log({
    3: f"{Fore.BLACK}Found {Fore.WHITE}{Style.BRIGHT}{len(rules)}{Fore.BLACK}{Style.NORMAL} rules{Style.RESET_ALL}"
  })
  return rules

def checkrule_verbose(rule, project_path):
  log({
    2: f"{Fore.BLACK}Checking: {Fore.WHITE}{rule['file']}{Style.RESET_ALL}",
    3: f"{Fore.BLACK}Validating rule {total}: {Fore.WHITE}{rule}{Style.RESET_ALL}"
  })
  base.validaterule(rule)
  if 'renamedfrom' in rule:
    log({
      3: f"{Fore.BLACK}Checking renamedfrom{Style.RESET_ALL}"
    })
    base.checkrenamedfrom(rule, project_path)
  if 'contains' in rule:
    log({
      3: f"{Fore.BLACK}Checking contains{Style.RESET_ALL}"
    })
    base.checkcontains(rule, project_path)

  log({
    2: f"{Fore.GREEN}Watermark found{Style.RESET_ALL}"
  })


if __name__ == '__main__':
  try:
    # Initialize colorama
    just_fix_windows_console()

    args = init_verbose()
    project_path = load_env_verbose()
    total = 0
    found = 0
    rules = getrules_verbose(args.file)

    for rule in rules:
      total += 1
      try:
        checkrule_verbose(rule, project_path)
        found += 1
      except base.RuleConfigurationError as e:
        logRuleConfigurationError(e)
      except base.WatermarkException as e:
        logWatermarkException(e)

    logresult(found, total)
  except Exception as e:
    logException(e)
    exit(1)