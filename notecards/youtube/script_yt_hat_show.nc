#
#   A complicated show
#
#   Start with some introductory music
#
Play handel_hwv_351
Script pause 10
#
#   Open the top and fire initial salvo
#
Set top off
Script pause 0.5
Salvo 20
Wait
#
#   Release the ants!
#
Script pause 0.5
Launch ants
Wait
#
#   Now launch another, shorter salvo
#
Salvo 15
Wait
Script pause 1
#
#   Launch final blow-out salvo
#
Set interval 0
Set radius 2 5
Salvo 10
Wait
#   Restore salvo/launch defaults
Set interval 0.75 2.5
Set radius 2 5
Set top on
