# th-bandesystem

Et avanceret bandesystem, lavet til at holde styr på din serveres bander.


# Exports

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
