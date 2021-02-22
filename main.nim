import std/[random, os]

const totalUnit = 34
const Usage = """
FE8 Swapperizer - Growth Rates Edition

Usage:
  $ fe8_swapperizer fe8.gba
  $ your-emulator fe8modified.gba
"""

type
  UnitInfo = object
    name: string
    address: int
    origRate: array[7, uint8]
    newRate: array[7, uint8]

proc genSeqNumber(): array[totalUnit, uint8] {.compileTime.} =
  var arr: array[totalUnit, uint8]
  for i in 0..<totalUnit: arr[i] = i.uint8
  arr

proc printUsage() =
  stdout.write(Usage)
  stdout.flushFile()
  quit(0)

proc setOrigRate(f: File, units: var array[totalUnit, UnitInfo]) =
  var i = 0
  while i < units.len:
    f.setFilePos(units[i].address)
    discard readBytes(f, units[i].origRate, 0, units[i].origRate.len)
    i += 1

proc setNewRate(units: var array[totalUnit, UnitInfo],
    indexArray: array[totalUnit, uint8]) =
  var i = 0
  while i < units.len:
    let pos = indexArray[i]
    units[i].newRate = units[pos].origRate
    i += 1

proc writeRom(f: File, filename: string, units: array[totalUnit, UnitInfo]) =
  var i = 0
  while i < units.len:
    f.setFilePos(units[i].address)
    discard writeBytes(f, units[i].newRate, 0, units[i].newRate.len)
    i += 1

var units = [
  UnitInfo(name: "Eirika", address: 0x8582D8),
  UnitInfo(name: "Seth", address: 0x85830C),
  UnitInfo(name: "Gilliam", address: 0x858340),
  UnitInfo(name: "Franz", address: 0x858374),
  UnitInfo(name: "Moulder", address: 0x8583A8),
  UnitInfo(name: "Vanessa", address: 0x8583DC),
  UnitInfo(name: "Ross", address: 0x858410),
  UnitInfo(name: "Neimi", address: 0x858444),
  UnitInfo(name: "Colm", address: 0x858478),
  UnitInfo(name: "Garcia", address: 0x8584AC),

  UnitInfo(name: "Innes", address: 0x8584E0),
  UnitInfo(name: "Lute", address: 0x858514),
  UnitInfo(name: "Natasha", address: 0x858548),
  UnitInfo(name: "Cormag", address: 0x85857C),
  UnitInfo(name: "Ephraim", address: 0x8585B0),
  UnitInfo(name: "Forde", address: 0x8585E4),
  UnitInfo(name: "Kyle", address: 0x858618),
  UnitInfo(name: "Amelia", address: 0x85864C),
  UnitInfo(name: "Artur", address: 0x858680),
  UnitInfo(name: "Gerik", address: 0x8586B4),

  UnitInfo(name: "Tethys", address: 0x8586E8),
  UnitInfo(name: "Marisa", address: 0x85871C),
  UnitInfo(name: "Saleh", address: 0x858750),
  UnitInfo(name: "Ewan", address: 0x858784),
  UnitInfo(name: "L'Arachel", address: 0x8587B8),
  UnitInfo(name: "Dozla", address: 0x8587EC),
  UnitInfo(name: "Rennac", address: 0x858854),
  UnitInfo(name: "Duessel", address: 0x858888),
  UnitInfo(name: "Myrrh", address: 0x8588BC),
  UnitInfo(name: "Knoll", address: 0x8588F0),

  UnitInfo(name: "Joshua", address: 0x858924),
  UnitInfo(name: "Syrene", address: 0x858958),
  UnitInfo(name: "Tana", address: 0x85898C),
  UnitInfo(name: "Orson", address: 0x8589F4),
]

var
  f: File
  indexArray = genSeqNumber()
  infile = "fe8.gba"
  outfile = "fe8modified.gba"

if not fileExists(infile):
  printUsage()

randomize()

indexArray.shuffle()

copyFile(infile, outfile)

if open(f, outfile, fmReadWriteExisting):
  setOrigRate(f, units)
  setNewRate(units, indexArray)
  writeRom(f, outfile, units)
  f.close()
else:
  printUsage()

when not defined(release):
  echo "NAME: HP, ATK, SKILL, SPD, DEF, RES, LUCK"
  echo ":: origRates"
  for u in units:
    echo u.name & ": " & $u.origRate
  echo ":: newRates"
  for u in units:
    echo u.name & ": " & $u.newRate
  echo ":: indexArray"
  echo indexArray
