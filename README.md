# th-bandesystem

Et avanceret bandesystem, lavet til at holde styr på din serveres bander.

# Features

- Indbygget skill system (Kan slås fra i config.lua)
- Indbygget bossmenu, med mulighed for tilføje samt fjerne medlemmer, og tjekke status på bandes skills
- Indbygget admin menu, med mulighed for at tilføje, ændre samt fjerne bander

# Exports

Dette er de exports, der er tilgængelige i scriptet.
Husk at alle exports returner en boolean.

## Check Level.

Dette export, bruges til at chekke om banden har det rigtige level

```lua
    exports["th-bandesystem"]:CheckLevel(skill, level)
```

Eksempel:
Her tjekker vi om bande har level 5 i house robbery

```lua
    exports["th-bandesystem"]:CheckLevel('house_robbery', 5)
```

## Add XP

Dette export, bruges til at tilføje xp til en bandes skills

```lua
    exports["th-bandesystem"]:AddExp(skill, point)
```

Eksempel:
Her vil vi tilføje 2 xp-point til bandes hus røveri skill

```lua
    exports["th-bandesystem"]:AddExp('house_robbery', 2)
```

# Setup

1. Download scriptet, og smid det ind i din resources mappe

2. Kør databasen

3. Nyd dit nye script fra th-development!
