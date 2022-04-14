local player <const> = playdate.sound.sampleplayer

SoundManager = {}

SoundManager.kPause    = 'exact_bloop'
SoundManager.kResume   = 'happy_click'
SoundManager.kTimerEnd = 'elegant_chime'

local sounds <const> = {}

for _, v in pairs(SoundManager) do
	sounds[v] = player.new('Sounds/'..v)
end

SoundManager.sounds = sounds

function SoundManager:play(name)
	self.sounds[name]:play(1)
end
