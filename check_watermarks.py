import os
import argparse
import yaml

# class ConfigurationFileNotFoundError(Exception):
#   # Exception raised when configuration file is not found
#   def __init__(self, filename, message="Configuration file not found")
#     self.filename = filename
#     super().__init__(message)

class RuleConfigurationError(Exception):
  # Exception raised when there is an error in one of the configuration rules
  def __init__(self, rule, message="There is an error in one of the configuration rules"):
    self.rule = rule
    super().__init__(message)

class WatermarkException(Exception):
  pass

class FileRenameWatermarkException(WatermarkException):
  # Exception raised when the watermark is not found
  def __init__(self, file, filefrom, message="The file is not renamed"):
    self.file = file
    self.filefrom = filefrom
    self.message = message
    super().__init__(message)

class FileContainsWatermarkException(WatermarkException):
  # Exception raised when the watermark is not found
  def __init__(self, file, contains, message="The file does not contain the watermark text"):
    self.file = file
    self.contains = contains
    super().__init__(message)


def init_argparser():
  # Initialize parser
  parser = argparse.ArgumentParser(description = "Check a Laravel project for watermarks")
  # Adding arguments
  parser.add_argument("file", 
                    help = "name of the yaml file")
  # Read arguments from command line
  return parser


def getrules(filename):
  # if not os.path.exists(filename):
  #   raise ConfigurationFileNotFoundError
  with open(filename, "r") as file:
    rules = yaml.safe_load(file)
  return rules


def validaterule(rule):
  if 'file' not in rule:
    raise RuleConfigurationError(rule, "Rule does not contain the file under consideration")
  if len(rule) != 2:
    raise RuleConfigurationError(rule, "Rule does not have exactly 2 properties")
  if "renamedfrom" not in rule and "contains" not in rule:
    raise RuleConfigurationError(rule, "The second argument is not valid")

def checkrenamedfrom(rule, project_path="./"):
  filename = os.path.join(project_path, rule['file'])
  filenamefrom = os.path.join(project_path, rule['renamedfrom'])
  fileexists = os.path.exists(filename)
  filefromexists = os.path.exists(filenamefrom)
  if not fileexists and not filefromexists:
    raise FileRenameWatermarkException(filename, filenamefrom, "Both files are not found")
  if filefromexists:
    raise FileRenameWatermarkException(filename, filenamefrom, "Original file still exists")

def checkcontains(rule, project_path="./"):
  filename = os.path.join(project_path, rule['file'])
  if not os.path.exists(filename):
    raise RuleConfigurationError(rule, "File under consideration does not exist")
  watermark = rule['contains']
  with open(filename, 'r') as f:
    if watermark not in f.read():
      raise FileContainsWatermarkException(filename, watermark)

if __name__ == '__main__':
  try:
    args = init_argparser().parse_args()
    rules = getrules(args.file)
    for rule in rules:
      validaterule()
      if 'renamedfrom' in rule:
        checkrenamedfrom(rule)
      if 'contains' in rule:
        checkcontains(rule)
  except WatermarkException:
    print("One of the watermarks is NOT found")
  except Exception as e:
    print("There is something wrong with the configuration and/or project")
  print("Found all watermarks")