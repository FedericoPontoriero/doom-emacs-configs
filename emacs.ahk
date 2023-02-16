#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

CapsLock:: Send {BackSpace}
!a::Send {Esc}
;----------- REMAPEO DE TECLAS A DVORAK

q::.
w::,
e::SC027 ; esta tecla es la "ñ"
r::p
t::y
y::f
u::g
i::c
o::h
p::l

;a::a ; no cambia
s::o
d::e
f::u
g::i
h::d
j::r
k::t
l::n
SC027::s

z::-
x::q
c::j
v::k
b::x
n::b
;m::m ; no cambia
,::w
.::v
-::z


^x:: Send ^x
return

^c:: Send ^c
return

^v:: Send ^v
return

^z:: Send ^z
return

<^>!a:: Send {!}
return

<^>!s:: Send {"}
return

<^>!d:: Send +3
return

<^>!f:: Send {$}
return

<^>!g:: Send +5
return

<^>!h:: Send {&}
return

<^>!j:: Send {/}
return

<^>!k:: Send {(}
return

<^>!l:: Send {)}
return

<^>!SC027:: Send {=}
return

<^>!1:: Send {|}
return

<^>!2:: Send {@}
return

<^>!4:: Send {~}
return

!j:: Send {Left}
return

!l:: Send {Right}
return

!i:: Send {Up}
return

!k:: Send {Down}
return

+!j:: Send +{Left}
return

+!l:: Send +{Right}
return

+!i:: Send +{Up}
return

+!k:: Send +{Down}
return

!q:: Send, !{F4}
return

!w:: Send ^w
return

+´:: Send {``}
return

^!p::Suspend ;

^+SPACE:: Winset, Alwaysontop, , A
