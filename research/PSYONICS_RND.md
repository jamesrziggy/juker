# Psyonics R&D Notes: Solomon's Key, the Gateway Process, and Recorded Oral Traditions

Research notes compiled 2026-07-04. Everything below is sourced; documented
facts are stated as facts, claims are labeled as claims made by the named
source. Links at the bottom.

---

## 1. The Gateway Process (declassified, CIA reading room)

**The document.** "Analysis and Assessment of the Gateway Process," written
in 1983 by Lt. Col. Wayne M. McDonnell for U.S. Army Intelligence
(INSCOM), assessing the Monroe Institute's Gateway Experience training.
Declassified 2003; hosted in the CIA FOIA reading room as
`CIA-RDP96-00788R001700210016-5`. It sits in the same records family as the
Stargate-era remote-viewing programs.

**The mechanism it studies: Hemi-Sync.** Binaural beats — play one pure
tone in the left ear and a slightly different one in the right (e.g. 400 Hz
and 410 Hz, or 100 Hz and 104 Hz). The brainstem resolves the difference and
produces a third, phantom beat at the differential frequency (10 Hz and 4 Hz
respectively). Via the frequency-following response, cortical activity tends
to entrain toward that differential. The differential is chosen to land in a
target brainwave band:

| band  | frequency  | associated state                    |
|-------|-----------|--------------------------------------|
| delta | < 4 Hz    | deep sleep                           |
| theta | 4–8 Hz    | hypnagogia, deep meditation, trance  |
| alpha | 8–13 Hz   | relaxed wakefulness                  |
| beta  | > 13 Hz   | alert cognition                      |

This part is ordinary, measurable acoustics and EEG — the beat frequency is
literally `|f_left − f_right|`.

**The Focus levels** (Monroe Institute training ladder the report assesses):
Focus 10 "mind awake / body asleep" → Focus 12 "expanded awareness" →
Focus 15 "no time" → Focus 21 "gateway to the nonphysical." The full
commercial Gateway Experience runs these as seven progressive audio "waves."

**The theoretical framework McDonnell builds.** He tries to give the
experiences a physics: consciousness modeled as energy in motion; time
defined as a measurement of change (energy in motion); the universe treated
as an interference pattern — leaning on Karl Pribram's holographic brain
model and David Bohm's implicate order, i.e. the brain as a Fourier-style
frequency analyzer reading a holographic field. The individual mind is
pictured as a toroidal energy pattern that, at sufficient coherence, can
"click out" of spacetime and attune to the "Absolute" — the undifferentiated
ground state. These are the report's hypotheses, not established physics;
McDonnell explicitly reaches for then-current theory (Bohm, Pribram) to
explain what Gateway trainees reported.

**The missing page 25.** The declassified PDF skipped page 25 for decades;
FOIA requests were denied on the grounds the CIA never had it. In 2021 the
page surfaced in the Monroe Institute's own archives in Faber, Virginia. It
opens with the section on the "Absolute" and discusses the relation between
the model and religious belief systems — reportedly withheld-by-accident
rather than conspiracy, but the gap fueled 40 years of speculation.

---

## 2. Solomon's Key

Two distinct documents get called this; the tradition runs oral → recorded →
systematized.

**Testament of Solomon (1st–5th c. CE, most scholars say ~3rd c.).** Greek
pseudepigraphon; the earliest extended written account of Solomon commanding
spirits. The archangel Michael gives Solomon a ring bearing a seal (in this
text a pentagram; the hexagram identification comes later via medieval
Arabic and Kabbalistic sources), with which he binds demons to build the
Temple, interrogating each for its name, star, and the angel that thwarts
it. This is the earliest known instance of summoning spirits for constructive
rather than malefic purposes — and it is itself a recording of older Jewish
oral lore: the Talmud (Gittin 68a) carries the parallel oral tradition of
Solomon, Asmodeus, and the ring engraved with the divine Name.

**Clavicula Salomonis / Key of Solomon (14th–15th c. Renaissance Italy).**
Pseudepigraphical grimoire attributed to Solomon, framed as written for his
son Roboam. Earliest external reference: Peter of Abano's *Lucidator*
(1303–1310). Oldest partial manuscript: ~1380–1410 (identified by Matteo
Cova); an Italian manuscript (BNF Ital. 1524) is dated 1446. The standard
modern edition is S. L. MacGregor Mathers' 1889 translation (which omits
chapters restored in later editions; Joseph Peterson's Esoteric Archives
carries the scholarly text).

**The math inside the Key.** The grimoire's operating system is timing and
geometry, not prose:

- *Planetary hours (unequal hours).* Daylight (sunrise→sunset) is divided
  into 12 equal parts, night (sunset→sunrise) into 12 more — so hour length
  varies with season and latitude. Rulers are assigned by stepping through
  the **Chaldean order** (Saturn, Jupiter, Mars, Sun, Venus, Mercury, Moon),
  starting from the weekday's ruler. Because 24 mod 7 = 3, stepping 24 hours
  advances the sequence by exactly three places — which is *why* the weekday
  cycle (Sun, Moon, Mars, Mercury, Jupiter, Venus, Saturn) is the Chaldean
  order sampled every third element. The weekday names encode the theorem.
- *Pentacles.* 44 planetary pentacles constructed per planet from divine
  names, psalm verses, and geometric figures, on the planet's metal, in the
  planet's day and hour. Construction = material × geometry × timing.
- The introduction tabulates hours, angelic names per hour, archangels,
  metals, colors per planet — a lookup-table architecture.

See `kona-master/docs/scripts/gateway_math.k` in this repo, which computes
the beat differentials, the entrainment tempos, and a full 24-hour unequal
planetary-hour table in K.

---

## 3. Recorded oral traditions

The pattern repeats across cultures: a practice transmitted orally for
centuries, then written down, and the written form preserves a *numerical
protocol*.

**Kabbalah** — the word means "received," i.e. it names itself an oral
transmission. Chabad sources describe the written texts as outlines whose
keys stayed oral within a small circle. When it was recorded, it was
recorded as number: *Sefer Yetzirah* (earliest extant Jewish esoteric work,
the only one mentioned in the Talmud) builds creation from the 10 sefirot —
literally "numbers" — plus the 22 Hebrew letters: the "32 paths of wisdom."
Gematria maps every word to an integer. The *Zohar* (13th c., attributed to
Shimon bar Yochai, scholarship credits Moses de León ~1250–1305, possibly
incorporating older material) is the oral stream's largest recording.

**Yoga Sutras of Patanjali, Book III (Vibhuti Pada)** — the sutra form *is*
a compression codec for oral transmission (terse lines memorized, expanded
by a teacher's commentary). Book III catalogs the siddhis arising from
samyama (concentration-meditation-absorption applied to an object):
knowledge of others' minds, perception of the distant and hidden, and the
rest — essentially a taxonomy of what would today be filed under psi.
Patanjali records them and immediately warns they are obstacles to the
actual goal.

**Shamanic drumming** — the oldest oral-tradition altered-state technology,
and the one where the math has been directly measured. Michael Harner's
"core shamanism" (distilled from South American fieldwork, 1960s–70s)
codified journey drumming at roughly 220 beats per minute ≈ 3.7–4.5 Hz.
Melinda Maxfield's 1990 EEG study found monotonous drumming at 4–4.5 beats
per second increased theta activity and evoked trance phenomena (flight
sensations, time distortion); later EEG work and a recent *Scientific
Reports* study found neural tracking at theta predicts drumming-induced
altered states. 4.5 Hz is inside the same theta band Hemi-Sync targets with
its 4 Hz binaural differential.

---

## 4. The convergence, through math

Strip the vocabulary from each system and a common numerical skeleton
remains — every recorded tradition specifies a **frequency or timing
protocol**:

| system                | parameter                       | number                  |
|-----------------------|---------------------------------|-------------------------|
| Gateway / Hemi-Sync   | binaural differential           | 4 Hz (theta), 10 Hz (alpha) |
| Shamanic journeying   | drum tempo                      | ~220 bpm ≈ 3.7–4.5 Hz (theta) |
| Key of Solomon        | operation timing                | unequal hours, Chaldean order mod 7 |
| Kabbalah              | structural constants            | 10 + 22 = 32 paths; gematria |
| Yoga Sutras           | transmission format             | sutra compression + graded samyama |

Two independent lineages — a 1980s Army-assessed audio lab and paleolithic
drum practice — converge on the same ~4 Hz theta target, and that
convergence is the strongest mathematically-grounded fact in this whole
space: theta entrainment by periodic audio stimulus is real, measurable EEG
physics. What the entrained state gives access to is where the documented
record ends and the claims begin: McDonnell's holographic-Absolute model,
the grimoires' spirit hierarchies, and Patanjali's siddhis are the three
traditions' respective explanations, and none has survived controlled
measurement to date.

The honest R&D frontier, then: the *entrainment math* is reproducible on a
bench (and in this repo's interpreter — run `gateway_math.k`); the *psi
claims* attached to the entrained states are the open question, and testing
them means feeding recorded session data from an entrained subject into
exactly the kind of scoring statistics parapsychology already uses.

---

## Sources

- CIA reading room, [Analysis and Assessment of Gateway Process (PDF)](https://www.cia.gov/readingroom/docs/cia-rdp96-00788r001700210016-5.pdf)
- Vice, [Found: Page 25 of the CIA's Gateway Report on Astral Projection](https://www.vice.com/en/article/found-page-25-of-the-cias-gateway-report-on-astral-projection/)
- Unknown Country, [The Missing Page Was at the Monroe Institute All Along](https://unknowncountry.com/headline-news/the-missing-page-to-a-classified-report-on-the-monroe-institute-was-at-the-monroe-institute-all-along/)
- stupidDOPE, [The CIA's Gateway Process Document — What It Actually Says](https://stupiddope.com/2026/05/the-cias-gateway-process-document-is-back-in-the-spotlight-heres-what-it-actually-says/)
- Masked Matrix, [How Hemi-Sync Works](https://maskedmatrix.com/how-hemi-sync-works/)
- Visionary Tide, [The 27 Focus Levels of the Gateway Experience](https://medium.com/@kennethdavidthomaskt/the-27-focus-levels-of-the-gateway-experience-a-journey-through-consciousness-53d514adcaaa)
- Wikipedia, [Key of Solomon](https://en.wikipedia.org/wiki/Key_of_Solomon), [Testament of Solomon](https://en.wikipedia.org/wiki/Testament_of_Solomon), [Seal of Solomon](https://en.wikipedia.org/wiki/Seal_of_Solomon), [Planetary hours](https://en.wikipedia.org/wiki/Planetary_hours), [Sefer Yetzirah](https://en.wikipedia.org/wiki/Sefer_Yetzirah), [Siddhi](https://en.wikipedia.org/wiki/Siddhi)
- Esoteric Archives, [The Key of Solomon, ed. Peterson/Mathers](https://www.esotericarchives.com/solomon/ksol.htm)
- Renaissance Astrology, [Planetary Hours and Days](https://www.renaissanceastrology.com/planetaryhoursarticle.html), [The Pentacles of Solomon](https://www.renaissanceastrology.com/solomonpentacles.html)
- intertextual.bible, [Testament of Solomon 1 / Gittin 68a](https://intertextual.bible/text/testament-of-solomon-1/gittin-68a)
- Chabad.org, [The Oral Tradition](https://www.chabad.org/library/article_cdo/aid/361876/jewish/The-Oral-Tradition.htm), [The Zohar](https://www.chabad.org/library/article_cdo/aid/361877/jewish/The-Zohar.htm)
- Britannica, [Sefer ha-zohar](https://www.britannica.com/topic/Sefer-ha-zohar)
- The Contemplative Life, [Yoga Sutras: Siddhis](https://www.thecontemplativelife.org/blog/yoga-sutras-patanjali-siddhis-mystic-powers)
- Open Access Pub, [EEG Responses to Shamanic Drumming](https://openaccesspub.org/sleep-and-sleep-disorder-research/article/eeg-responses-to-shamanic-drumming-does-the-suggestion-of-trance-state-moderate-the-strength-of-frequency-components-671)
- Scientific Reports, [Neural tracking at theta predicts drumming-induced altered states](https://www.nature.com/articles/s41598-026-37700-x)
- Cannelevate, [Shamanic Drumming & the Science of Altered States](https://www.cannelevate.com.au/article/shamanic-drumming-rhythmic-meditation-altered-consciousness)

Note: this environment's network policy blocked direct fetch of cia.gov,
Wikipedia/Wikisource, and esotericarchives.com; those entries were sourced
via search-result summaries and should be spot-checked against the primary
pages when read from an unrestricted connection.
