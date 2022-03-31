local snd <const> = playdate.sound

SoundManager = {}

SoundManager.kPause    = 'exact_bloop'
SoundManager.kResume   = 'happy_click'
SoundManager.kTimerEnd = 'elegant_chime'

local sounds = {}

for _, v in pairs(SoundManager) do
	sounds[v] = snd.sampleplayer.new('Sounds/' .. v)
end

SoundManager.sounds = sounds

function SoundManager:playSound(name)
	self.sounds[name]:play(1)
end
