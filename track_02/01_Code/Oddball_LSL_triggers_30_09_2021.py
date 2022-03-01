 #!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
This experiment was created using PsychoPy3 Experiment Builder (v3.0.7),
    on Sat May 11 14:00:55 2019
If you publish work using this script please cite the PsychoPy publications:
    Peirce, JW (2007) PsychoPy - Psychophysics software in Python.
        Journal of Neuroscience Methods, 162(1-2), 8-13.
    Peirce, JW (2009) Generating stimuli for neuroscience using PsychoPy.
        Frontiers in Neuroinformatics, 2:10. doi: 10.3389/neuro.11.010.2008
"""

from __future__ import absolute_import, division
from psychopy import locale_setup, sound, gui, visual, core, data, event, logging, clock
from psychopy.constants import (NOT_STARTED, STARTED, PLAYING, PAUSED,
                                STOPPED, FINISHED, PRESSED, RELEASED, FOREVER)
import numpy as np  # whole numpy lib is available, prepend 'np.'
from numpy import (sin, cos, tan, log, log10, pi, average,
                   sqrt, std, deg2rad, rad2deg, linspace, asarray)
from numpy.random import random, randint, normal, shuffle
import os  # handy system and path functions
import sys  # to get file system encoding
# import serial #connection to serial port
from time import sleep # load pause function

# I think you need to pip install pylsl first to make this work.
# Copy & paste the following string into your terminal: pip install pylsl

from pylsl import StreamInfo, StreamOutlet # import packages for LSL connection

# save stream info for LSL
info = StreamInfo(name='PsychoPy_Triggers', type='Markers', channel_count=1,
                  channel_format='int32', source_id='')
# source_id should be a unique identifier of the
# device / source of the data, if available (e.g. serial number)
# Default is ''

# nominal_srate is the sampling rate - change this if you
# send values with a certain sampling rate

# Initialize the stream
outlet = StreamOutlet(info)

# Ensure that relative paths start from the same directory as this script
_thisDir = os.path.dirname(os.path.abspath(__file__))
os.chdir(_thisDir)

# Store info about the experiment session
psychopyVersion = '3.0.7'
expName = 'P300_exp'  # from the Builder filename that created this script
expInfo = {'participant': '', 'session': '001'}
dlg = gui.DlgFromDict(dictionary=expInfo, title=expName)
if dlg.OK == False:
    core.quit()  # user pressed cancel
expInfo['date'] = data.getDateStr()  # add a simple timestamp
expInfo['expName'] = expName
expInfo['psychopyVersion'] = psychopyVersion

# Data file name stem = absolute path + name; later add .psyexp, .csv, .log, etc
filename = _thisDir + os.sep + u'data/%s_%s_%s' % (expInfo['participant'], expName, expInfo['date'])

# An ExperimentHandler isn't essential but helps with data saving
thisExp = data.ExperimentHandler(name=expName, version='',
    extraInfo=expInfo, runtimeInfo=None,
    originPath='/Users/Hiwi/Desktop/P300_Trigger_Merle/P300_exp.py',
    savePickle=True, saveWideText=True,
    dataFileName=filename)
# save a log file for detail verbose info
logFile = logging.LogFile(filename+'.log', level=logging.EXP)
logging.console.setLevel(logging.WARNING)  # this outputs to the screen, not a file

endExpNow = False  # flag for 'escape' or other condition => quit the exp

# Start Code - component code to be run before the window creation
# set connection to the serial port
#serial_port = serial.Serial('COM6', baudrate=115200, bytesize=serial.EIGHTBITS)
#serial_port.write(1) # send start signal to the serial port

# The nexus EEG needs some triggers to synchronize the system, so we send 5 triggers before we start
for i in range(5):
    print(i)
    #serial_port.write(bytes([255])) # send triggers to Nexus
    outlet.push_sample(x=[255]) # send triggers to LSL as well
    sleep(1) # 1 second pause between triggers

# Setup the Window
win = visual.Window(
    size=(1024, 768), fullscr=True, screen=0,
    allowGUI=False, allowStencil=False,
    monitor='testMonitor', color=[0,0,0], colorSpace='rgb',
    blendMode='avg', useFBO=True,
    units='height')
# store frame rate of monitor if we can measure it
expInfo['frameRate'] = win.getActualFrameRate()
if expInfo['frameRate'] != None:
    frameDur = 1.0 / round(expInfo['frameRate'])
else:
    frameDur = 1.0 / 60.0  # could not measure, so guess

# Initialize components for Routine "Instr_1"
Instr_1Clock = core.Clock()
text = visual.TextStim(win=win, name='text',
    text='Hallo liebe Versuchsperson!\n\nIm folgenden Experiment geht es darum, \nstill bestimmte Targetreize zu mitzuzählen. \n\nZähle im folgenden ersten Block bitte nur die \nblauen Targets. \n\nViel Spaß!\n\n(Zum Starten des ersten Blocks bitte die W-Taste drücken!)',
    font='Arial',
    pos=(0, 0), height=0.02, wrapWidth=None, ori=0,
    color='white', colorSpace='rgb', opacity=1,
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "fixation"
fixationClock = core.Clock()
fix_cross_1 = visual.ShapeStim(
    win=win, name='fix_cross_1', vertices='cross',
    size=(0.1, 0.1),
    ori=0, pos=(0, 0),
    lineWidth=1, lineColor=[-1.000,-1.000,-1.000], lineColorSpace='rgb',
    fillColor=[-1.000,-1.000,-1.000], fillColorSpace='rgb',
    opacity=1, depth=0.0, interpolate=True)

# Initialize components for Routine "trial_1"
trial_1Clock = core.Clock()
fix_1 = visual.ShapeStim(
    win=win, name='fix_1', vertices='cross',
    size=(0.1, 0.1),
    ori=0, pos=(0, 0),
    lineWidth=1, lineColor=[-1.000,-1.000,-1.000], lineColorSpace='rgb',
    fillColor=[-1.000,-1.000,-1.000], fillColorSpace='rgb',
    opacity=1, depth=0.0, interpolate=True)
stim_1 = visual.Polygon(
    win=win, name='stim_1',units='cm',
    edges=40000, size=(3.9, 3.9),
    ori=0, pos=(0, 0),
    lineWidth=1, lineColor=1.0, lineColorSpace='rgb',
    fillColor=1.0, fillColorSpace='rgb',
    opacity=1, depth=-1.0, interpolate=True)

# Initialize components for Routine "Instr_2"
Instr_2Clock = core.Clock()
text_2 = visual.TextStim(win=win, name='text_2',
    text='Sehr gut! \n\nDu kannst jetzt eine Pause machen.\n\nIm nächsten Block geht es darum, die roten Targets zu zählen.\nDrücke bitte die W-Taste, wenn du bereit\nbist fortzufahren. ',
    font='Arial',
    pos=(0, 0), height=0.02, wrapWidth=None, ori=0,
    color='white', colorSpace='rgb', opacity=1,
    languageStyle='LTR',
    depth=-1.0);

# Initialize components for Routine "trial_2"
trial_2Clock = core.Clock()
fix = visual.ShapeStim(
    win=win, name='fix', vertices='cross',
    size=(0.1, 0.1),
    ori=0, pos=(0, 0),
    lineWidth=1, lineColor=[-1.000,-1.000,-1.000], lineColorSpace='rgb',
    fillColor=[-1.000,-1.000,-1.000], fillColorSpace='rgb',
    opacity=1, depth=0.0, interpolate=True)
stim = visual.Polygon(
    win=win, name='stim',units='cm',
    edges=40000, size=(3.9, 3.9),
    ori=0, pos=(0, 0),
    lineWidth=1, lineColor=1.0, lineColorSpace='rgb',
    fillColor=1.0, fillColorSpace='rgb',
    opacity=1, depth=-1.0, interpolate=True)

# Initialize components for Routine "Instr_3"
Instr_3Clock = core.Clock()
text_3 = visual.TextStim(win=win, name='text_3',
    text='Sehr gut! \n\nDu kannst jetzt eine Pause machen.\n\nIm nächsten Block geht es darum, die blauen Targets zu zählen.\nDrücke bitte die W-Taste, wenn du bereit\nbist fortzufahren. ',
    font='Arial',
    pos=(0, 0), height=0.02, wrapWidth=None, ori=0,
    color='white', colorSpace='rgb', opacity=1,
    languageStyle='LTR',
    depth=0.0);

# Initialize components for Routine "trial_3"
trial_3Clock = core.Clock()
fix_2 = visual.ShapeStim(
    win=win, name='fix_2', vertices='cross',
    size=(0.1, 0.1),
    ori=0, pos=(0, 0),
    lineWidth=1, lineColor=[-1.000,-1.000,-1.000], lineColorSpace='rgb',
    fillColor=[-1.000,-1.000,-1.000], fillColorSpace='rgb',
    opacity=1, depth=0.0, interpolate=True)
stim_2 = visual.Polygon(
    win=win, name='stim_2',units='cm',
    edges=40000, size=(3.9, 3.9),
    ori=0, pos=(0, 0),
    lineWidth=1, lineColor=1.0, lineColorSpace='rgb',
    fillColor=1.0, fillColorSpace='rgb',
    opacity=1, depth=-1.0, interpolate=True)

# Initialize components for Routine "Instr_4"
Instr_4Clock = core.Clock()
text_4 = visual.TextStim(win=win, name='text_4',
    text='Sehr gut! \n\nDu kannst jetzt eine Pause machen.\n\nIm nächsten Block geht es darum, die roten Targets zu zählen.\nDrücke bitte die W-Taste, wenn du bereit\nbist fortzufahren.',
    font='Arial',
    pos=(0, 0), height=0.02, wrapWidth=None, ori=0,
    color='white', colorSpace='rgb', opacity=1,
    languageStyle='LTR',
    depth=-1.0);

# Initialize components for Routine "trial_4"
trial_4Clock = core.Clock()
fix_3 = visual.ShapeStim(
    win=win, name='fix_3', vertices='cross',
    size=(0.1, 0.1),
    ori=0, pos=(0, 0),
    lineWidth=1, lineColor=[-1.000,-1.000,-1.000], lineColorSpace='rgb',
    fillColor=[-1.000,-1.000,-1.000], fillColorSpace='rgb',
    opacity=1, depth=0.0, interpolate=True)
stim_3 = visual.Polygon(
    win=win, name='stim_3',units='cm',
    edges=40000, size=(3.9, 3.9),
    ori=0, pos=(0, 0),
    lineWidth=1, lineColor=1.0, lineColorSpace='rgb',
    fillColor=1.0, fillColorSpace='rgb',
    opacity=1, depth=-1.0, interpolate=True)

# Initialize components for Routine "end_2"
end_2Clock = core.Clock()
text_5 = visual.TextStim(win=win, name='text_5',
    text='Geschafft!\n\nVielen Dank für die Teilnahme!\n\nDu kannst das Experiment mit der W-Taste beenden.\n\n',
    font='Arial',
    pos=(0, 0), height=0.02, wrapWidth=None, ori=0,
    color='white', colorSpace='rgb', opacity=1,
    languageStyle='LTR',
    depth=0.0);

# Create some handy timers
globalClock = core.Clock()  # to track the time since experiment started
routineTimer = core.CountdownTimer()  # to track time remaining of each (non-slip) routine

# ------Prepare to start Routine "Instr_1"-------
t = 0
Instr_1Clock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_2 = event.BuilderKeyResponse()
# keep track of which components have finished
Instr_1Components = [text, key_resp_2]
for thisComponent in Instr_1Components:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "Instr_1"-------
while continueRoutine:
    # get current time
    t = Instr_1Clock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame

    # *text* updates
    if t >= 0.0 and text.status == NOT_STARTED:
        # keep track of start time/frame for later
        text.tStart = t
        text.frameNStart = frameN  # exact frame index
        text.setAutoDraw(True)

    # *key_resp_2* updates
    if t >= 0.0 and key_resp_2.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_2.tStart = t
        key_resp_2.frameNStart = frameN  # exact frame index
        key_resp_2.status = STARTED
        # keyboard checking is just starting
        win.callOnFlip(key_resp_2.clock.reset)  # t=0 on next screen flip
        event.clearEvents(eventType='keyboard')
    if key_resp_2.status == STARTED:
        theseKeys = event.getKeys(keyList=['w'])

        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            key_resp_2.keys = theseKeys[-1]  # just the last key pressed
            key_resp_2.rt = key_resp_2.clock.getTime()
            # a response ends the routine
            continueRoutine = False

    # check for quit (typically the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()

    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in Instr_1Components:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished

    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "Instr_1"-------
for thisComponent in Instr_1Components:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if key_resp_2.keys in ['', [], None]:  # No response was made
    key_resp_2.keys=None
thisExp.addData('key_resp_2.keys',key_resp_2.keys)
if key_resp_2.keys != None:  # we had a response
    thisExp.addData('key_resp_2.rt', key_resp_2.rt)
thisExp.nextEntry()
# the Routine "Instr_1" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "fixation"-------
t = 0
fixationClock.reset()  # clock
frameN = -1
continueRoutine = True
routineTimer.add(1.000000)
# update component parameters for each repeat
# keep track of which components have finished
fixationComponents = [fix_cross_1]
for thisComponent in fixationComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "fixation"-------
while continueRoutine and routineTimer.getTime() > 0:
    # get current time
    t = fixationClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame

    # *fix_cross_1* updates
    if t >= 0.0 and fix_cross_1.status == NOT_STARTED:
        # keep track of start time/frame for later
        fix_cross_1.tStart = t
        fix_cross_1.frameNStart = frameN  # exact frame index
        fix_cross_1.setAutoDraw(True)
    frameRemains = 0.0 + 1.0- win.monitorFramePeriod * 0.75  # most of one frame period left
    if fix_cross_1.status == STARTED and t >= frameRemains:
        fix_cross_1.setAutoDraw(False)

    # check for quit (typically the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()

    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in fixationComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished

    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "fixation"-------
for thisComponent in fixationComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)

# set up handler to look after randomisation of conditions etc
Block_1 = data.TrialHandler(nReps=1, method='sequential',
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('color_1.xlsx'),
    seed=None, name='Block_1')
thisExp.addLoop(Block_1)  # add the loop to the experiment
thisBlock_1 = Block_1.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisBlock_1.rgb)
if thisBlock_1 != None:
    for paramName in thisBlock_1:
        exec('{} = thisBlock_1[paramName]'.format(paramName))

for thisBlock_1 in Block_1:
    currentLoop = Block_1
    # abbreviate parameter names if possible (e.g. rgb = thisBlock_1.rgb)
    if thisBlock_1 != None:
        for paramName in thisBlock_1:
            exec('{} = thisBlock_1[paramName]'.format(paramName))

    # ------Prepare to start Routine "trial_1"-------
    t = 0
    trial_1Clock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    stim_1.setFillColor(color)
    stim_1.setLineColor(color)
    fixduration_1 = randint(low=15, high=20)/10


    # Define the Trigger Value for this Trial based on the excel-file, column called "code"
    trigval = thisBlock_1["code"]
    print(trigval) # Print just for good measure


    # keep track of which components have finished
    trial_1Components = [fix_1, stim_1]
    for thisComponent in trial_1Components:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED

    # -------Start Routine "trial_1"-------
    while continueRoutine:
        # get current time
        t = trial_1Clock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame

        # *fix_1* updates
        if t >= 0.0 and fix_1.status == NOT_STARTED:
            # keep track of start time/frame for later
            fix_1.tStart = t
            fix_1.frameNStart = frameN  # exact frame index
            fix_1.setAutoDraw(True)
        frameRemains = 0.0 + fixduration_1- win.monitorFramePeriod * 0.75  # most of one frame period left
        if fix_1.status == STARTED and t >= frameRemains:
            fix_1.setAutoDraw(False)

        # *stim_1* updates
        if (fix_1.status==FINISHED) and stim_1.status == NOT_STARTED:
            # keep track of start time/frame for later
            stim_1.tStart = t
            stim_1.frameNStart = frameN  # exact frame index
            stim_1.setAutoDraw(True)


            # send triggers
            #serial_port.write(bytes([trigval])) # send the trigger value defined before
            outlet.push_sample(x=[trigval]) # send trigger to LSL as well

        if stim_1.status == STARTED and t >= (stim_1.tStart + .066):
            stim_1.setAutoDraw(False)

        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()

        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in trial_1Components:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished

        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()

    # -------Ending Routine "trial_1"-------
    for thisComponent in trial_1Components:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # the Routine "trial_1" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()

# completed 1 repeats of 'Block_1'


# ------Prepare to start Routine "Instr_2"-------
t = 0
Instr_2Clock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_3 = event.BuilderKeyResponse()
# keep track of which components have finished
Instr_2Components = [key_resp_3, text_2]
for thisComponent in Instr_2Components:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "Instr_2"-------
while continueRoutine:
    # get current time
    t = Instr_2Clock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame

    # *key_resp_3* updates
    if t >= 0.0 and key_resp_3.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_3.tStart = t
        key_resp_3.frameNStart = frameN  # exact frame index
        key_resp_3.status = STARTED
        # keyboard checking is just starting
        win.callOnFlip(key_resp_3.clock.reset)  # t=0 on next screen flip
        event.clearEvents(eventType='keyboard')
    if key_resp_3.status == STARTED:
        theseKeys = event.getKeys(keyList=['w'])

        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            key_resp_3.keys = theseKeys[-1]  # just the last key pressed
            key_resp_3.rt = key_resp_3.clock.getTime()
            # a response ends the routine
            continueRoutine = False

    # *text_2* updates
    if t >= 0.0 and text_2.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_2.tStart = t
        text_2.frameNStart = frameN  # exact frame index
        text_2.setAutoDraw(True)

    # check for quit (typically the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()

    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in Instr_2Components:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished

    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "Instr_2"-------
for thisComponent in Instr_2Components:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if key_resp_3.keys in ['', [], None]:  # No response was made
    key_resp_3.keys=None
thisExp.addData('key_resp_3.keys',key_resp_3.keys)
if key_resp_3.keys != None:  # we had a response
    thisExp.addData('key_resp_3.rt', key_resp_3.rt)
thisExp.nextEntry()
# the Routine "Instr_2" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "fixation"-------
t = 0
fixationClock.reset()  # clock
frameN = -1
continueRoutine = True
routineTimer.add(1.000000)
# update component parameters for each repeat
# keep track of which components have finished
fixationComponents = [fix_cross_1]
for thisComponent in fixationComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "fixation"-------
while continueRoutine and routineTimer.getTime() > 0:
    # get current time
    t = fixationClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame

    # *fix_cross_1* updates
    if t >= 0.0 and fix_cross_1.status == NOT_STARTED:
        # keep track of start time/frame for later
        fix_cross_1.tStart = t
        fix_cross_1.frameNStart = frameN  # exact frame index
        fix_cross_1.setAutoDraw(True)
    frameRemains = 0.0 + 1.0- win.monitorFramePeriod * 0.75  # most of one frame period left
    if fix_cross_1.status == STARTED and t >= frameRemains:
        fix_cross_1.setAutoDraw(False)

    # check for quit (typically the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()

    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in fixationComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished

    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "fixation"-------
for thisComponent in fixationComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)

# set up handler to look after randomisation of conditions etc
Block_2 = data.TrialHandler(nReps=1, method='sequential',
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('color_2.xlsx'),
    seed=None, name='Block_2')
thisExp.addLoop(Block_2)  # add the loop to the experiment
thisBlock_2 = Block_2.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisBlock_2.rgb)
if thisBlock_2 != None:
    for paramName in thisBlock_2:
        exec('{} = thisBlock_2[paramName]'.format(paramName))

for thisBlock_2 in Block_2:
    currentLoop = Block_2
    # abbreviate parameter names if possible (e.g. rgb = thisBlock_2.rgb)
    if thisBlock_2 != None:
        for paramName in thisBlock_2:
            exec('{} = thisBlock_2[paramName]'.format(paramName))

    # ------Prepare to start Routine "trial_2"-------
    t = 0
    trial_2Clock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    stim.setFillColor(color)
    stim.setLineColor(color)
    fixduration_1 = randint(low=15, high=20)/10


    # Define the Trigger Value for this Trial based on the excel-file, column called "code"
    trigval = thisBlock_2["code"]
    print(trigval) # Print just for good measure




    # keep track of which components have finished
    trial_2Components = [fix, stim]
    for thisComponent in trial_2Components:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED

    # -------Start Routine "trial_2"-------
    while continueRoutine:
        # get current time
        t = trial_2Clock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame

        # *fix* updates
        if t >= 0.0 and fix.status == NOT_STARTED:
            # keep track of start time/frame for later
            fix.tStart = t
            fix.frameNStart = frameN  # exact frame index
            fix.setAutoDraw(True)


        frameRemains = 0.0 + fixduration_1- win.monitorFramePeriod * 0.75  # most of one frame period left
        if fix.status == STARTED and t >= frameRemains:
            fix.setAutoDraw(False)

        # *stim* updates
        if (fix_1.status==FINISHED) and stim.status == NOT_STARTED:
            # keep track of start time/frame for later
            stim.tStart = t
            stim.frameNStart = frameN  # exact frame index
            stim.setAutoDraw(True)

            # send triggers
            #serial_port.write(bytes([trigval])) # send the trigger value defined before
            outlet.push_sample(x=[trigval]) # send trigger to LSL as well

        if stim.status == STARTED and t >= (stim.tStart + .066):
            stim.setAutoDraw(False)

        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()

        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in trial_2Components:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished

        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()

    # -------Ending Routine "trial_2"-------
    for thisComponent in trial_2Components:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # the Routine "trial_2" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()

# completed 1 repeats of 'Block_2'


# ------Prepare to start Routine "Instr_3"-------
t = 0
Instr_3Clock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_4 = event.BuilderKeyResponse()
# keep track of which components have finished
Instr_3Components = [text_3, key_resp_4]
for thisComponent in Instr_3Components:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "Instr_3"-------
while continueRoutine:
    # get current time
    t = Instr_3Clock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame

    # *text_3* updates
    if t >= 0.0 and text_3.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_3.tStart = t
        text_3.frameNStart = frameN  # exact frame index
        text_3.setAutoDraw(True)

    # *key_resp_4* updates
    if t >= 0.0 and key_resp_4.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_4.tStart = t
        key_resp_4.frameNStart = frameN  # exact frame index
        key_resp_4.status = STARTED
        # keyboard checking is just starting
        win.callOnFlip(key_resp_4.clock.reset)  # t=0 on next screen flip
        event.clearEvents(eventType='keyboard')
    if key_resp_4.status == STARTED:
        theseKeys = event.getKeys(keyList=['w'])

        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            key_resp_4.keys = theseKeys[-1]  # just the last key pressed
            key_resp_4.rt = key_resp_4.clock.getTime()
            # a response ends the routine
            continueRoutine = False

    # check for quit (typically the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()

    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in Instr_3Components:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished

    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "Instr_3"-------
for thisComponent in Instr_3Components:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if key_resp_4.keys in ['', [], None]:  # No response was made
    key_resp_4.keys=None
thisExp.addData('key_resp_4.keys',key_resp_4.keys)
if key_resp_4.keys != None:  # we had a response
    thisExp.addData('key_resp_4.rt', key_resp_4.rt)
thisExp.nextEntry()
# the Routine "Instr_3" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "fixation"-------
t = 0
fixationClock.reset()  # clock
frameN = -1
continueRoutine = True
routineTimer.add(1.000000)
# update component parameters for each repeat
# keep track of which components have finished
fixationComponents = [fix_cross_1]
for thisComponent in fixationComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "fixation"-------
while continueRoutine and routineTimer.getTime() > 0:
    # get current time
    t = fixationClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame

    # *fix_cross_1* updates
    if t >= 0.0 and fix_cross_1.status == NOT_STARTED:
        # keep track of start time/frame for later
        fix_cross_1.tStart = t
        fix_cross_1.frameNStart = frameN  # exact frame index
        fix_cross_1.setAutoDraw(True)
    frameRemains = 0.0 + 1.0- win.monitorFramePeriod * 0.75  # most of one frame period left
    if fix_cross_1.status == STARTED and t >= frameRemains:
        fix_cross_1.setAutoDraw(False)

    # check for quit (typically the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()

    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in fixationComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished

    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "fixation"-------
for thisComponent in fixationComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)

# set up handler to look after randomisation of conditions etc
Block_3 = data.TrialHandler(nReps=1, method='sequential',
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('color_3.xlsx'),
    seed=None, name='Block_3')
thisExp.addLoop(Block_3)  # add the loop to the experiment
thisBlock_3 = Block_3.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisBlock_3.rgb)
if thisBlock_3 != None:
    for paramName in thisBlock_3:
        exec('{} = thisBlock_3[paramName]'.format(paramName))

for thisBlock_3 in Block_3:
    currentLoop = Block_3
    # abbreviate parameter names if possible (e.g. rgb = thisBlock_3.rgb)
    if thisBlock_3 != None:
        for paramName in thisBlock_3:
            exec('{} = thisBlock_3[paramName]'.format(paramName))

    # ------Prepare to start Routine "trial_3"-------
    t = 0
    trial_3Clock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    stim_2.setFillColor(color)
    stim_2.setLineColor(color)
    fixduration_1 = randint(low=15, high=20)/10


    # Define the Trigger Value for this Trial based on the excel-file, column called "trigval"
    trigval = thisBlock_3["code"]
    print(trigval) # Print just for good measure



    # keep track of which components have finished
    trial_3Components = [fix_2, stim_2]
    for thisComponent in trial_3Components:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED

    # -------Start Routine "trial_3"-------
    while continueRoutine:
        # get current time
        t = trial_3Clock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame

        # *fix_2* updates
        if t >= 0.0 and fix_2.status == NOT_STARTED:
            # keep track of start time/frame for later
            fix_2.tStart = t
            fix_2.frameNStart = frameN  # exact frame index
            fix_2.setAutoDraw(True)
        frameRemains = 0.0 + fixduration_1- win.monitorFramePeriod * 0.75  # most of one frame period left
        if fix_2.status == STARTED and t >= frameRemains:
            fix_2.setAutoDraw(False)

        # *stim_2* updates
        if (fix_1.status==FINISHED) and stim_2.status == NOT_STARTED:
            # keep track of start time/frame for later
            stim_2.tStart = t
            stim_2.frameNStart = frameN  # exact frame index
            stim_2.setAutoDraw(True)

            # send triggers
            #serial_port.write(bytes([trigval])) # send the trigger value defined before
            outlet.push_sample(x=[trigval]) # send trigger to LSL as well

        if stim_2.status == STARTED and t >= (stim_2.tStart + .066):
            stim_2.setAutoDraw(False)


        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()

        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in trial_3Components:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished

        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()

    # -------Ending Routine "trial_3"-------
    for thisComponent in trial_3Components:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # the Routine "trial_3" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()

# completed 1 repeats of 'Block_3'


# ------Prepare to start Routine "Instr_4"-------
t = 0
Instr_4Clock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_5 = event.BuilderKeyResponse()
# keep track of which components have finished
Instr_4Components = [key_resp_5, text_4]
for thisComponent in Instr_4Components:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "Instr_4"-------
while continueRoutine:
    # get current time
    t = Instr_4Clock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame

    # *key_resp_5* updates
    if t >= 0.0 and key_resp_5.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_5.tStart = t
        key_resp_5.frameNStart = frameN  # exact frame index
        key_resp_5.status = STARTED
        # keyboard checking is just starting
        win.callOnFlip(key_resp_5.clock.reset)  # t=0 on next screen flip
        event.clearEvents(eventType='keyboard')
    if key_resp_5.status == STARTED:
        theseKeys = event.getKeys(keyList=['w'])

        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            key_resp_5.keys = theseKeys[-1]  # just the last key pressed
            key_resp_5.rt = key_resp_5.clock.getTime()
            # a response ends the routine
            continueRoutine = False

    # *text_4* updates
    if t >= 0.0 and text_4.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_4.tStart = t
        text_4.frameNStart = frameN  # exact frame index
        text_4.setAutoDraw(True)

    # check for quit (typically the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()

    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in Instr_4Components:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished

    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "Instr_4"-------
for thisComponent in Instr_4Components:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if key_resp_5.keys in ['', [], None]:  # No response was made
    key_resp_5.keys=None
thisExp.addData('key_resp_5.keys',key_resp_5.keys)
if key_resp_5.keys != None:  # we had a response
    thisExp.addData('key_resp_5.rt', key_resp_5.rt)
thisExp.nextEntry()
# the Routine "Instr_4" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()

# ------Prepare to start Routine "fixation"-------
t = 0
fixationClock.reset()  # clock
frameN = -1
continueRoutine = True
routineTimer.add(1.000000)
# update component parameters for each repeat
# keep track of which components have finished
fixationComponents = [fix_cross_1]
for thisComponent in fixationComponents:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "fixation"-------
while continueRoutine and routineTimer.getTime() > 0:
    # get current time
    t = fixationClock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame

    # *fix_cross_1* updates
    if t >= 0.0 and fix_cross_1.status == NOT_STARTED:
        # keep track of start time/frame for later
        fix_cross_1.tStart = t
        fix_cross_1.frameNStart = frameN  # exact frame index
        fix_cross_1.setAutoDraw(True)
    frameRemains = 0.0 + 1.0- win.monitorFramePeriod * 0.75  # most of one frame period left
    if fix_cross_1.status == STARTED and t >= frameRemains:
        fix_cross_1.setAutoDraw(False)

    # check for quit (typically the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()

    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in fixationComponents:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished

    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "fixation"-------
for thisComponent in fixationComponents:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)

# set up handler to look after randomisation of conditions etc
Block_4 = data.TrialHandler(nReps=1, method='sequential',
    extraInfo=expInfo, originPath=-1,
    trialList=data.importConditions('color_4.xlsx'),
    seed=None, name='Block_4')
thisExp.addLoop(Block_4)  # add the loop to the experiment
thisBlock_4 = Block_4.trialList[0]  # so we can initialise stimuli with some values
# abbreviate parameter names if possible (e.g. rgb = thisBlock_4.rgb)
if thisBlock_4 != None:
    for paramName in thisBlock_4:
        exec('{} = thisBlock_4[paramName]'.format(paramName))

for thisBlock_4 in Block_4:
    currentLoop = Block_4
    # abbreviate parameter names if possible (e.g. rgb = thisBlock_4.rgb)
    if thisBlock_4 != None:
        for paramName in thisBlock_4:
            exec('{} = thisBlock_4[paramName]'.format(paramName))

    # ------Prepare to start Routine "trial_4"-------
    t = 0
    trial_4Clock.reset()  # clock
    frameN = -1
    continueRoutine = True
    # update component parameters for each repeat
    stim_3.setFillColor(color)
    stim_3.setLineColor(color)
    fixduration_1 = randint(low=15, high=20)/10


    # Define the Trigger Value for this Trial based on the excel-file, column called "trigval"
    trigval = thisBlock_4["code"]
    print(trigval) # Print just for good measure


    # keep track of which components have finished
    trial_4Components = [fix_3, stim_3]
    for thisComponent in trial_4Components:
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED

    # -------Start Routine "trial_4"-------
    while continueRoutine:
        # get current time
        t = trial_4Clock.getTime()
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame

        # *fix_3* updates
        if t >= 0.0 and fix_3.status == NOT_STARTED:
            # keep track of start time/frame for later
            fix_3.tStart = t
            fix_3.frameNStart = frameN  # exact frame index
            fix_3.setAutoDraw(True)
        frameRemains = 0.0 + fixduration_1- win.monitorFramePeriod * 0.75  # most of one frame period left
        if fix_3.status == STARTED and t >= frameRemains:
            fix_3.setAutoDraw(False)

        # *stim_3* updates
        if (fix_1.status==FINISHED) and stim_3.status == NOT_STARTED:
            # keep track of start time/frame for later
            stim_3.tStart = t
            stim_3.frameNStart = frameN  # exact frame index
            stim_3.setAutoDraw(True)

            # send triggers
            #serial_port.write(bytes([trigval])) # send the trigger value defined before
            outlet.push_sample(x=[trigval]) # send trigger to LSL as well

        if stim_3.status == STARTED and t >= (stim_3.tStart + .066):
            stim_3.setAutoDraw(False)

        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()

        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in trial_4Components:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished

        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()

    # -------Ending Routine "trial_4"-------
    for thisComponent in trial_4Components:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)
    # the Routine "trial_4" was not non-slip safe, so reset the non-slip timer
    routineTimer.reset()
    thisExp.nextEntry()

# completed 1 repeats of 'Block_4'


# ------Prepare to start Routine "end_2"-------
t = 0
end_2Clock.reset()  # clock
frameN = -1
continueRoutine = True
# update component parameters for each repeat
key_resp_6 = event.BuilderKeyResponse()
# keep track of which components have finished
end_2Components = [text_5, key_resp_6]
for thisComponent in end_2Components:
    if hasattr(thisComponent, 'status'):
        thisComponent.status = NOT_STARTED

# -------Start Routine "end_2"-------
while continueRoutine:
    # get current time
    t = end_2Clock.getTime()
    frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
    # update/draw components on each frame

    # *text_5* updates
    if t >= 0.0 and text_5.status == NOT_STARTED:
        # keep track of start time/frame for later
        text_5.tStart = t
        text_5.frameNStart = frameN  # exact frame index
        text_5.setAutoDraw(True)
    frameRemains = 0.0 + 10- win.monitorFramePeriod * 0.75  # most of one frame period left
    if text_5.status == STARTED and t >= frameRemains:
        text_5.setAutoDraw(False)

    # *key_resp_6* updates
    if t >= 0.0 and key_resp_6.status == NOT_STARTED:
        # keep track of start time/frame for later
        key_resp_6.tStart = t
        key_resp_6.frameNStart = frameN  # exact frame index
        key_resp_6.status = STARTED
        # keyboard checking is just starting
        win.callOnFlip(key_resp_6.clock.reset)  # t=0 on next screen flip
        event.clearEvents(eventType='keyboard')
    if key_resp_6.status == STARTED:
        theseKeys = event.getKeys(keyList=['w'])

        # check for quit:
        if "escape" in theseKeys:
            endExpNow = True
        if len(theseKeys) > 0:  # at least one key was pressed
            key_resp_6.keys = theseKeys[-1]  # just the last key pressed
            key_resp_6.rt = key_resp_6.clock.getTime()
            # a response ends the routine
            continueRoutine = False

    # check for quit (typically the Esc key)
    if endExpNow or event.getKeys(keyList=["escape"]):
        core.quit()

    # check if all components have finished
    if not continueRoutine:  # a component has requested a forced-end of Routine
        break
    continueRoutine = False  # will revert to True if at least one component still running
    for thisComponent in end_2Components:
        if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
            continueRoutine = True
            break  # at least one component has not yet finished

    # refresh the screen
    if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
        win.flip()

# -------Ending Routine "end_2"-------
for thisComponent in end_2Components:
    if hasattr(thisComponent, "setAutoDraw"):
        thisComponent.setAutoDraw(False)
# check responses
if key_resp_6.keys in ['', [], None]:  # No response was made
    key_resp_6.keys=None
thisExp.addData('key_resp_6.keys',key_resp_6.keys)
if key_resp_6.keys != None:  # we had a response
    thisExp.addData('key_resp_6.rt', key_resp_6.rt)
thisExp.nextEntry()
# the Routine "end_2" was not non-slip safe, so reset the non-slip timer
routineTimer.reset()
# these shouldn't be strictly necessary (should auto-save)
thisExp.saveAsWideText(filename+'.csv')
thisExp.saveAsPickle(filename)
logging.flush()


# close connection to the serial port
#serial_port.close()


# make sure everything else is closed down
thisExp.abort()  # or data files will save again on exit
win.close()
core.quit()
