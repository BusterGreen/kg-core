KGConfig = {}

KGConfig.MaxPlayers = GetConvarInt('sv_maxclients', 48) -- Gets max players from config file, default 48
KGConfig.DefaultSpawn = vector4(-1035.71, -2731.87, 12.86, 0.0)
KGConfig.UpdateInterval = 5                             -- how often to update player data in minutes
KGConfig.StatusInterval = 5000                          -- how often to check hunger/thirst status in milliseconds

KGConfig.Money = {}
KGConfig.Money.MoneyTypes = { cash = 500, bank = 5000, crypto = 0 } -- type = startamount - Add or remove money types for your server (for ex. blackmoney = 0), remember once added it will not be removed from the database!
KGConfig.Money.DontAllowMinus = { 'cash', 'crypto' }                -- Money that is not allowed going in minus
KGConfig.Money.PayCheckTimeOut = 10                                 -- The time in minutes that it will give the paycheck
KGConfig.Money.PayCheckSociety = false                              -- If true paycheck will come from the society account that the player is employed at, requires kg-management

KGConfig.Player = {}
KGConfig.Player.HungerRate = 4.2 -- Rate at which hunger goes down.
KGConfig.Player.ThirstRate = 3.8 -- Rate at which thirst goes down.
KGConfig.Player.Bloodtypes = {
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',
}

KGConfig.Player.PlayerDefaults = {
    citizenid = function() return KGCore.Player.CreateCitizenId() end,
    cid = 1,
    money = function()
        local moneyDefaults = {}
        for moneytype, startamount in pairs(KGConfig.Money.MoneyTypes) do
            moneyDefaults[moneytype] = startamount
        end
        return moneyDefaults
    end,
    optin = true,
    charinfo = {
        firstname = 'Firstname',
        lastname = 'Lastname',
        birthdate = '00-00-0000',
        gender = 0,
        nationality = 'USA',
        phone = function() return KGCore.Functions.CreatePhoneNumber() end,
        account = function() return KGCore.Functions.CreateAccountNumber() end
    },
    job = {
        name = 'unemployed',
        label = 'Civilian',
        payment = 10,
        type = 'none',
        onduty = false,
        isboss = false,
        grade = {
            name = 'Freelancer',
            level = 0
        }
    },
    gang = {
        name = 'none',
        label = 'No Gang Affiliation',
        isboss = false,
        grade = {
            name = 'none',
            level = 0
        }
    },
    metadata = {
        hunger = 100,
        thirst = 100,
        stress = 0,
        isdead = false,
        inlaststand = false,
        armor = 0,
        ishandcuffed = false,
        tracker = false,
        injail = 0,
        jailitems = {},
        status = {},
        phone = {},
        rep = {},
        currentapartment = nil,
        callsign = 'NO CALLSIGN',
        bloodtype = function() return KGConfig.Player.Bloodtypes[math.random(1, #KGConfig.Player.Bloodtypes)] end,
        fingerprint = function() return KGCore.Player.CreateFingerId() end,
        walletid = function() return KGCore.Player.CreateWalletId() end,
        criminalrecord = {
            hasRecord = false,
            date = nil
        },
        licences = {
            driver = true,
            business = false,
            weapon = false
        },
        inside = {
            house = nil,
            apartment = {
                apartmentType = nil,
                apartmentId = nil,
            }
        },
        phonedata = {
            SerialNumber = function() return KGCore.Player.CreateSerialNumber() end,
            InstalledApps = {}
        }
    },
    position = KGConfig.DefaultSpawn,
    items = {},
}

KGConfig.Server = {}                                    -- General server config
KGConfig.Server.Closed = false                          -- Set server closed (no one can join except people with ace permission 'kgadmin.join')
KGConfig.Server.ClosedReason = 'Server Closed'          -- Reason message to display when people can't join the server
KGConfig.Server.Uptime = 0                              -- Time the server has been up.
KGConfig.Server.Whitelist = false                       -- Enable or disable whitelist on the server
KGConfig.Server.WhitelistPermission = 'admin'           -- Permission that's able to enter the server when the whitelist is on
KGConfig.Server.PVP = true                              -- Enable or disable pvp on the server (Ability to shoot other players)
KGConfig.Server.Discord = ''                            -- Discord invite link
KGConfig.Server.CheckDuplicateLicense = true            -- Check for duplicate rockstar license on join
KGConfig.Server.Permissions = { 'god', 'admin', 'mod' } -- Add as many groups as you want here after creating them in your server.cfg

KGConfig.Commands = {}                                  -- Command Configuration
KGConfig.Commands.OOCColor = { 255, 151, 133 }          -- RGB color code for the OOC command

KGConfig.Notify = {}

KGConfig.Notify.NotificationStyling = {
    group = false,      -- Allow notifications to stack with a badge instead of repeating
    position = 'right', -- top-left | top-right | bottom-left | bottom-right | top | bottom | left | right | center
    progress = true     -- Display Progress Bar
}

-- These are how you define different notification variants
-- The "color" key is background of the notification
-- The "icon" key is the css-icon code, this project uses `Material Icons` & `Font Awesome`
KGConfig.Notify.VariantDefinitions = {
    success = {
        classes = 'success',
        icon = 'check_circle'
    },
    primary = {
        classes = 'primary',
        icon = 'notifications'
    },
    warning = {
        classes = 'warning',
        icon = 'warning'
    },
    error = {
        classes = 'error',
        icon = 'error'
    },
    police = {
        classes = 'police',
        icon = 'local_police'
    },
    ambulance = {
        classes = 'ambulance',
        icon = 'fas fa-ambulance'
    }
}
