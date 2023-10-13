#source code for testing
import flet as ft
import tempfile,os

#BUNDLE_PATH passed from the outside swift wrapper
if os.environ.get('BUNDLE_PATH'):
    #os.getcwd() will provide the app sandbox path, 
    #cannot access any file outside the sandbox directory (except request user permission in swift)
    tempfile.tempdir = os.getcwd()+os.sep+'tmp'


def main(page: ft.Page):
    page.title = "Flet counter example"
    page.vertical_alignment = ft.MainAxisAlignment.CENTER

    txt_number = ft.TextField(value="0", text_align=ft.TextAlign.RIGHT, width=100)

    def minus_click(e):
        txt_number.value = str(int(txt_number.value) - 1)
        page.update()

    def plus_click(e):
        txt_number.value = str(int(txt_number.value) + 1)
        page.update()

    page.add(
        ft.Row(
            [
                ft.IconButton(ft.icons.REMOVE, on_click=minus_click),
                txt_number,
                ft.IconButton(ft.icons.ADD, on_click=plus_click),
            ],
            alignment=ft.MainAxisAlignment.CENTER,
        )
    )

# in app mode, after run pyinstaller, unzip the flet-macos-amd64.tar.gz in _internal/flet/bin
ft.app(target=main)
# in web browser mode,after run pyinstaller,copy the flet/web folder to _internal/flet
# ft.app(target=main,view=ft.AppView.WEB_BROWSER)