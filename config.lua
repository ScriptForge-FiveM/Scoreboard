Config = {}
Config.open = 57 -- Default open key (57 = F10)
Config.jobs = { -- Main job counter
    police = 'police',
    ambulance = 'ambulance',
    mechanic = 'mechanic',
}

Config.allowedIdentifiers = {
 "char1:e6ac7c08e7dd257665045f47eafdb8d40fa11309" -- Character identifier can be found in table "users" column "identifier"
}

Config.businessPermissions = { -- Permission to open and close a business based on job and grade
    { job = 'police', grade = 4 },    
    { job = 'mechanic', grade = 4 }
}
