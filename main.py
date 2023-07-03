import multiprocessing
import pyautogui
import time
from datetime import datetime
import PySimpleGUI as sg


def keepUI():
    EOD = datetime.today().replace(hour=17, minute=00)
    sg.theme = 'Dark'
    layout = [
        [sg.Text('Script is now running. You can keep it minimized and it will continue running until: ')],
        [sg.Push(),
         sg.Text("17:00", font=("Arial", 16), text_color='black', background_color='white', key='-END_VALUE-'),
         sg.Push()],
        [sg.Text('This script will turn the volume up/down every: '),
         sg.Text("60", key='-DISPLAY_IVAL-'), sg.Text("Seconds")],
        [sg.Text('\nSet End Time (HH:MM)'), sg.Input(default_text='17:00', key='-TIME-')],
        [sg.Text('Set Interval Time (Seconds)'),
         sg.Slider(range=(10, 300), default_value=60, orientation='horizontal', key='-IVAL-')],
        [sg.Push(), sg.Button("Update Script", key='-UPDATE_SCRIPT-', button_color='green'), sg.Push()],
        [sg.Text('Updates remaining: '), sg.Text("5", key='-UPDATES-')],
        [sg.Button('STOP SCRIPT', key='Cancel')]
    ]
    window = sg.Window('keepMeUp', layout)
    dynamic_procs = {}
    numProcs = 2
    proc_name = f"p{numProcs}"
    dynamic_procs[proc_name] = multiprocessing.Process(target=dontsleep, args=(EOD,))
    dynamic_procs[proc_name].start()

    while True:
        event, values = window.read()
        if event == sg.WIN_CLOSED or event == 'Cancel':
            if dynamic_procs[proc_name].is_alive():
                dynamic_procs[proc_name].terminate()
            break
        if event == '-UPDATE_SCRIPT-':
            strTime = values['-TIME-']
            strIVAL = values['-IVAL-']
            IVAL = int(strIVAL)
            try:
                datetime.strptime(strTime, '%H:%M')  # not using obj created but parse for correct format
                hh = int(strTime.split(':')[0])
                mm = int(strTime.split(':')[1])
                EOD = datetime.today().replace(hour=hh, minute=mm)
                window['-END_VALUE-'].update(strTime)
                window['-DISPLAY_IVAL-'].update(IVAL)
                if dynamic_procs[proc_name].is_alive():
                    dynamic_procs[proc_name].terminate()
                numProcs += 1
                window['-UPDATES-'].update(7 - numProcs)
                proc_name = f"p{numProcs}"
                dynamic_procs[proc_name] = multiprocessing.Process(target=dontsleep, args=(EOD, IVAL))
                dynamic_procs[proc_name].start()
            except ValueError:
                sg.popup_error("Invalid time format. Please provide time in HH:MM format.")
            if numProcs > 7:
                if dynamic_procs[proc_name].is_alive():
                    dynamic_procs[proc_name].terminate()
                print("Too many processes created. Shutting down script for safety, feel free to restart.")
                sg.popup_error("Only 5 updates allowed per run. Shutting down after error prompt close")
                break


def dontsleep(EOD: datetime, Interval: int = 60):
    while True:
        if datetime.now() > EOD:
            break
        pyautogui.press('volumedown')
        time.sleep(Interval)
        pyautogui.press('volumeup')
        time.sleep(Interval)


if __name__ == '__main__':
    p1 = multiprocessing.Process(target=keepUI)
    p1.start()
