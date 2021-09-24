# Stat Track

A simple application to track everything you want

<a href='https://play.google.com/store/apps/details?id=de.lukas.stattrack&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png' height='80px'/></a>

## Description
Stat Track is an app that lets you track numbers, text and many more and export it to JSON.

Examples to track:
- Expenses
- Sleep
- Work time
- Training progress
- Health
- Wellbeing
- ...

## Analyse your Data
You can analyse your Stat Track data on your computer with the <a href='https://github.com/hertelukas/stattrack-analyser'>Stat Track Analyser</a> or use the <a href='https://stattrack.lukas-hertel.de/'>online analyser</a>.

Such a json file might look something like this:
<details>
  <summary>Click me!</summary>
  
```json
{
  "entries": [
    {
      "date": "2021-09-20T17:43:58.168673",
      "fields": {
        "Warmup": true,
        "Effectiveness": 7.0,
        "Squats": 40,
        "Push-ups": 25,
        "Comment": "Nice workout"
      }
    },
    {
      "date": "2021-09-21T17:45:14.472420",
      "fields": {
        "Warmup": true,
        "Effectiveness": 8.0,
        "Squats": 42,
        "Push-ups": 28,
        "Comment": "Hard workout, but nice progress"
      }
    },
    {
      "date": "2021-09-22T16:54:52.331305",
      "fields": {
        "Warmup": false,
        "Effectiveness": 4.0,
        "Squats": 36,
        "Push-ups": 18,
        "Comment": "Only quick warm up, no time today"
      }
    },
    {
      "date": "2021-09-23T18:57:07.910150",
      "fields": {
        "Warmup": true,
        "Effectiveness": 7.0,
        "Squats": 48,
        "Push-ups": 20,
        "Comment": "Good workout, squats went very well"
      }
    },
    {
      "date": "2021-09-25T16:00:36.702878",
      "fields": {
        "Warmup": true,
        "Effectiveness": 9.0,
        "Squats": 50,
        "Push-ups": 30,
        "Comment": "\"Pause\" was worth it"
      }
    },
    {
      "date": "2021-09-26T17:03:48.516354",
      "fields": {
        "Warmup": true,
        "Effectiveness": 7.0,
        "Squats": 42,
        "Push-ups": 32,
        "Comment": "No strength in the legs today"
      }
    },
    {
      "date": "2021-09-27T18:05:48.516354",
      "fields": {
        "Warmup": true,
        "Effectiveness": 7.0,
        "Squats": 40,
        "Push-ups": 32,
        "Sleep": 8,
        "Comment": "I think I should track my sleep"
      }
    }
  ]
}
```
</details>

## Screenshots
<p>
<img src="images/screenshot_track.jpg?raw=true" alt="track" width="200"> 
<img src="images/screenshot_config.jpg?raw=true" alt="config" width="200">
<img src="images/screenshot_history.jpg?raw=true" alt="history" width="200">
</p>

## Contributing
Thanks for helping with this project! To contribute, please read [this](.github/CONTRIBUTING.md).


### Colors
- Main: #28AFB0
- Secondary: #9191E9
- Background: #30343F
- Background 2: #1B2021
