-- Absolute Screenshot
--   uses exiftool to get the "Date/Time Original" and saves a screenshot
--   with the actual time the video was taken

local utils = require 'mp.utils'

function screenshot_timestamp()
  pos = mp.get_property_native("time-pos")

  path = mp.get_property("path")
  t = { args = { "exiftool", "-T", "-DateTimeOriginal",  path },
        capture_stdout = true,
        capture_stderr = true,
      }
  --res = mp.command_native(t)
  res = utils.subprocess(t)
  if res and res.error == nil then
    -- mp.msg.info(res.stdout)

    -- parse timestamp
    local pattern = "(%d+)%:(%d+)%:(%d+) (%d+):(%d+):(%d+)%+(%d+)"
    local xyear, xmonth, xday, xhour, xminute,
          xseconds, xmillies, xoffset = res.stdout:match(pattern)
    local convertedTimestamp = os.time({year = xyear, month = xmonth,
          day = xday, hour = xhour, min = xminute, sec = xseconds})
    -- collect screenshot info
    dir = mp.get_property_native("screenshot-directory")
    if (string.len(dir) > 0) then dir = dir..'/' end
    fname = mp.get_property_native("filename/no-ext")
    fmat = mp.get_property_native("screenshot-format")
    dt = dir..fname..os.date("-%Y-%m-%d-%H-%m-%S", convertedTimestamp+pos)..string.sub(pos%1, 2)..'.'..fmat
    -- save screenshot
    mp.commandv("screenshot-to-file", dt, "subtitles")
  else
    mp.msg.warn("FAIL!")
    mp.msg.warn(res)
  end
end

mp.add_key_binding("CTRL+S", 'screenshot-timestamp', screenshot_timestamp)
