var names = new Array("DEVELOPER2", "SUMMER ", "DONATOR LVL 7", "TESTER", "TOP", "SPRING", "DEVELOPER", "MODERATOR", "NEW YEAR", "AUTUMN", "DONATOR LVL 1", "DONATOR LVL 2", "DONATOR LVL 3", "DONATOR LVL 4", "DONATOR LVL 5", "DONATOR LVL 6", "COLD FIRE", "WINTER 2", "WINTER 3", "SUPRISE", "AUTUMN TOP1", "SPRING 2", "BIRTHDAY", "DIRT", "AUTUMN TOP2-3", "STORM", "DONATOR LVL 8", "DONATOR LVL 9", "DONATOR LVL 10", "AUTUMN 2", "SUMMER 2", "DONATOR LVL 11", "DONATOR LVL 11", "DONATOR LVL 11", "DONATOR LVL 11", "WINTER TOP2-3", "WINTER TOP1", "SPRING TOP1", "SPRING TOP2", "SPRING TOP3", "SUMMER TOP1", "SUMMER TOP2", "SUMMER TOP3", "DONATOR LVL 12", "TOP PATREON");
					//     1              2         3          4            5           6         7           8             9          10            11              12               13             14              15          16                     17       18           19           20        21     22          23          24       25       26         27               28                29              30             31           32         33                 34                35                 36
var needs = new Array(false, "#summer", "#patron7", "#tester", "#top", "#spring", "#developer2", "#moderator", "#newyear", "#autumn", "#patron1", "#patron2", "#patron3", "#patron4", "#patron5", "#patron6", "#coldfire", "#winter2", "#winter3", "#suprise", "#top1", "#spring2", "#birthday", "#dirt", "#top2-3", "#storm", "#patron8", "#patron9", "#patron10", "#autumn2", "#summer2", "#patron11", "#patron11", "#patron11", "#patron11", "#top2-3", "top1", "top1", "top2", "top3", "top1", "top2", "top3", "patron12","toppatron");
var poriadok = new Array(0, 3, 7, 6, 10, 11, 12, 13, 14, 15, 1, 2, 4, 8, 9, 16, 5, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,40,41,42,43,44,45,46);//"#birthday2"
					//   1  2  3  4  5   6    7   8  9   10 11 12 13 14 15  16  17  18 19  20
function UpdateParticles( table_name, key, data )
{
    var ID = Players.GetLocalPlayer();
	//$.Msg( ID, ": ", "Table ", table_name, " changed: '", key, "' = ", data );
    var myint = 1;
    if (ID == key)
    {
        if (data != null)
        {
            for (var x = 1; x < names.length+1; x = x + 1)
            {
                if (data[poriadok[x-1]+1] != null)
                {
                    $("#NAPartButt"+x).visible = false;
                    if (data[poriadok[x-1]+1] != "nill")
                    {
                        if (data[poriadok[x-1]+1] != "normal")
                        {
                            $("#NewPartButt"+myint).visible = true;
                            $("#partname"+myint).text = names[poriadok[x-1]];
                            $("#partnote"+myint).text = data[poriadok[x-1]+1];
                            $("#NewPartNum"+myint).text = poriadok[x-1]+1;

                            if ($("#NewTooltip"+myint) == null)
                            {
                                $.CreatePanelWithProperties(`Panel`, $("#NewPartButt"+myint), `NewTooltip${myint}`, {
                                    class: `NewTooltip`,
                                    onmouseover: `UIShowCustomLayoutParametersTooltip(ParticleTooltip${myint},file://{resources}/layout/custom_game/particles_tooltips.xml,num=${poriadok[x-1]+1}`, 
                                    onmouseout: `UIHideCustomLayoutTooltip(ParticleTooltip${myint})`,
                                });
                            }
                            else
                            {
                                $("#NewTooltip"+myint).RemoveAndDeleteChildren();
                                $.CreatePanelWithProperties(`Panel`, $("#NewPartButt"+myint), `NewTooltip${myint}`, {
                                    class: `NewTooltip`,
                                    onmouseover: `UIShowCustomLayoutParametersTooltip(ParticleTooltip${myint},file://{resources}/layout/custom_game/particles_tooltips.xml,num=${poriadok[x-1]+1}`, 
                                    onmouseout: `UIHideCustomLayoutTooltip(ParticleTooltip${myint})`,
                                });
                            }
                            myint = myint + 1;
                        }
                        else 
                        {
                            $("#NewPartButt"+myint).visible = true;
                            $("#partname"+myint).text = names[poriadok[x-1]];
                            $("#partnote"+myint).text = $.Localize("#" + needs[poriadok[x-1]]);
                            $("#NewPartNum"+myint).text = poriadok[x-1]+1;
                            if ($("#NewTooltip"+myint) == null)
                            {
                                $.CreatePanelWithProperties(`Panel`, $("#NewPartButt"+myint), `NewTooltip${myint}`, {
                                    class: `NewTooltip`,
                                    onmouseover: `UIShowCustomLayoutParametersTooltip(ParticleTooltip${myint},file://{resources}/layout/custom_game/particles_tooltips.xml,num=${poriadok[x-1]+1}`, 
                                    onmouseout: `UIHideCustomLayoutTooltip(ParticleTooltip${myint})`,
                                });
                            }
                            else
                            {
                                $("#NewTooltip"+myint).RemoveAndDeleteChildren();
                                $.CreatePanelWithProperties(`Panel`, $("#NewPartButt"+myint), `NewTooltip${myint}`, {
                                    class: `NewTooltip`,
                                    onmouseover: `UIShowCustomLayoutParametersTooltip(ParticleTooltip${myint},file://{resources}/layout/custom_game/particles_tooltips.xml,num=${poriadok[x-1]+1}`, 
                                    onmouseout: `UIHideCustomLayoutTooltip(ParticleTooltip${myint})`,
                                });
                            }
                            myint = myint + 1;
                        }
                    }
                    else
                    {
                        if (needs[poriadok[x-1]] != false)
                        {
                            $("#NAPartButt"+myint).visible = true;
                            $("#napartname"+myint).text = names[poriadok[x-1]];
                            $("#napartnote"+myint).text = $.Localize("#" + needs[poriadok[x-1]]);
                            if ($("#NewTooltip"+myint) == null)
                            {
                                $.CreatePanelWithProperties(`Panel`, $("#NAPartButt"+myint), `NewTooltip${myint}`, {
                                    class: `NewTooltip`,
                                    onmouseover: `UIShowCustomLayoutParametersTooltip(ParticleTooltip${myint},file://{resources}/layout/custom_game/particles_tooltips.xml,num=${poriadok[x-1]+1}`, 
                                    onmouseout: `UIHideCustomLayoutTooltip(ParticleTooltip${myint})`,
                                });
                            }
                            else
                            {
                                $("#NewTooltip"+myint).RemoveAndDeleteChildren();
                                $.CreatePanelWithProperties(`Panel`, $("#NAPartButt"+myint), `NewTooltip${myint}`, {
                                    class: `NewTooltip`,
                                    onmouseover: `UIShowCustomLayoutParametersTooltip(ParticleTooltip${myint},file://{resources}/layout/custom_game/particles_tooltips.xml,num=${poriadok[x-1]+1}`, 
                                    onmouseout: `UIHideCustomLayoutTooltip(ParticleTooltip${myint})`,
                                });
                            }
                            myint = myint + 1;
                        }
                    }
                }
                else
                {
                    if (needs[poriadok[x-1]] != false)
                    {
                        $("#NAPartButt"+myint).visible = true;
                        $("#napartname"+myint).text = names[poriadok[x-1]];
                        $("#napartnote"+myint).text = $.Localize("#" + needs[poriadok[x-1]]);
                        if ($("#NewTooltip"+myint) == null)
                        {
                            $.CreatePanelWithProperties(`Panel`, $("#NAPartButt"+myint), `NewTooltip${myint}`, {
                                class: `NewTooltip`,
                                onmouseover: `UIShowCustomLayoutParametersTooltip(ParticleTooltip${myint},file://{resources}/layout/custom_game/particles_tooltips.xml,num=${poriadok[x-1]+1}`, 
                                onmouseout: `UIHideCustomLayoutTooltip(ParticleTooltip${myint})`,
                            });
                        }
                        else
                        {
                            $("#NewTooltip"+myint).RemoveAndDeleteChildren();
                            $.CreatePanelWithProperties(`Panel`, $("#NAPartButt"+myint), `NewTooltip${myint}`, {
                                class: `NewTooltip`,
                                onmouseover: `UIShowCustomLayoutParametersTooltip(ParticleTooltip${myint},file://{resources}/layout/custom_game/particles_tooltips.xml,num=${poriadok[x-1]+1}`, 
                                onmouseout: `UIHideCustomLayoutTooltip(ParticleTooltip${myint})`,
                            });
                        }
                        myint = myint + 1;
                    }
                }
            }
        }
        else
        {
            for (var x = 1; x < names.length+1; x = x + 1)
            {
                if (needs[poriadok[x-1]] != false)
                {
                    $("#NAPartButt"+myint).visible = true;
                    $("#napartname"+myint).text = names[poriadok[x-1]];
                    $("#napartnote"+myint).text = $.Localize("#" + needs[poriadok[x-1]]);
                    if ($("#NewTooltip"+myint) == null)
                    {
                        $.CreatePanelWithProperties(`Panel`, $("#NAPartButt"+myint), `NewTooltip${myint}`, {
                            class: `NewTooltip`,
                            onmouseover: `UIShowCustomLayoutParametersTooltip(ParticleTooltip${myint},file://{resources}/layout/custom_game/particles_tooltips.xml,num=${poriadok[x-1]+1}`, 
                            onmouseout: `UIHideCustomLayoutTooltip(ParticleTooltip${myint})`,
                        });
                    }
                    else
                    {
                        $("#NewTooltip"+myint).RemoveAndDeleteChildren();
                        $.CreatePanelWithProperties(`Panel`, $("#NAPartButt"+myint), `NewTooltip${myint}`, {
                            class: `NewTooltip`,
                            onmouseover: `UIShowCustomLayoutParametersTooltip(ParticleTooltip${myint},file://{resources}/layout/custom_game/particles_tooltips.xml,num=${poriadok[x-1]+1}`, 
                            onmouseout: `UIHideCustomLayoutTooltip(ParticleTooltip${myint})`,
                        });
                    }
                    myint = myint + 1;
                }
            }
        }
    }
}
var selectedpart = null;
function SelectPart(num)
{
    if (selectedpart != num)
    {
        if (selectedpart != null)
        {
            $("#partapngb"+selectedpart).visible = false;
        }
        GameEvents.SendCustomGameEventToServer( "SelectPart", { id: Players.GetLocalPlayer(),part:$("#NewPartNum"+num).text, offp:false, name:$("#partname"+num).text } );
        $("#partapngb"+num).visible = true;
        selectedpart = num;
    }
    else
    {
        GameEvents.SendCustomGameEventToServer( "SelectPart", { id: Players.GetLocalPlayer(),part:$("#NewPartNum"+num).text, offp:true, name:$("#partname"+num).text } );
        $("#partapngb"+selectedpart).visible = false;
        selectedpart = null;
    }
    //$.Msg("SelectedPart = "+selectedpart);
}

function DefaultButtonReady()
{
    $("#DefaultButton").RemoveClass("DefaultButtondis");
    $("#DefaultButton").AddClass("DefaultButtonact");
}

function DefaultButton()
{
    if (selectedpart != null)
    {
        GameEvents.SendCustomGameEventToServer( "SetDefaultPart", { id: Players.GetLocalPlayer(),part:$("#NewPartNum"+selectedpart).text} );
        $.Msg($("#NewPartNum"+selectedpart).text);
    }
    else
    {
        GameEvents.SendCustomGameEventToServer( "SetDefaultPart", { id: Players.GetLocalPlayer(),part:""} );
    } 
    $("#DefaultButton").RemoveClass("DefaultButtonact");
    $("#DefaultButton").AddClass("DefaultButtondis");
}

function SetSelectedParticles(data)
{
    for (var x = 1; x < names.length+1; x = x + 1)
    {
        if ($("#NewPartNum"+x).text == data["3"])
            selectedpart = x.toString();
    }
    $("#partapngb"+selectedpart).visible = true;
}

(function()
{
    GameEvents.Subscribe( "DefaultButtonReady", DefaultButtonReady);
    GameEvents.Subscribe( "SetSelectedParticles", SetSelectedParticles);
    for (var x = 1; x < names.length+1; x = x + 1)
    {
        var stl = (100*(x-1)) + 20

        $.CreatePanelWithProperties(`Button`, $("#CustomUIContainer"), `NewPartButt${x}`, {
            class: `NewPartButt`,
            style: `margin-top:${stl}px;`,
            onactivate: `SelectPart(${x})`, 
        });
        $.CreatePanelWithProperties("Image", $("#NewPartButt"+x), `pereg${x}`, { src:"file://{images}/custom_game/all/st.png", style: "width:5px; margin-top:0px; margin-left:150px;" });
        $.CreatePanelWithProperties("Image", $("#NewPartButt"+x), `partapngb${x}`, { src: "file://{images}/custom_game/all/activbutt.png"});   
        $.CreatePanelWithProperties("Label", $("#NewPartButt"+x), `NewPartNum${x}`, {text: '0' });
        $.CreatePanelWithProperties("Label", $("#NewPartButt"+x), `partname${x}`, { style: "margin-top:20px; margin-left:10px;", text: "Название эффекта" });
        $.CreatePanelWithProperties("Label", $("#NewPartButt"+x), `partnote${x}`, { style: "margin-top:5px; margin-left:180px;", text: "Описание/причина выдачи/примечание" });






        $("#NewPartButt"+x).visible = false;
        $("#NewPartNum"+x).visible = false;
        $("#partapngb"+x).visible = false;

        $.CreatePanelWithProperties(`Button`, $("#CustomUIContainer"), `NAPartButt${x}`, {
            class: `NAPartButt`,
            style: `margin-top:${stl}px;`,
            onactivate: `SelectPart(${x})`, 
        });
        $.CreatePanelWithProperties("Image", $("#NAPartButt"+x), `napereg${x}`, { src: "file://{images}/custom_game/all/st.png", style: 'width:5px; margin-top:0px; margin-left:150px;'});  
        $.CreatePanelWithProperties("Label", $("#NAPartButt"+x), `napartname${x}`, { style: "margin-top:20px; margin-left:10px;", text: "Название эффекта" });
        $.CreatePanelWithProperties("Label", $("#NAPartButt"+x), `napartnote${x}`, { style: "margin-top:5px; margin-left:180px;", text: "Описание/причина выдачи/примечание" });

        $("#NAPartButt"+x).visible = false;
    }
    CustomNetTables.SubscribeNetTableListener( "Particles_Tabel", UpdateParticles );
    UpdateParticles( "Particles_Tabel", Players.GetLocalPlayer(), CustomNetTables.GetTableValue( "Particles_Tabel", Players.GetLocalPlayer() ) );
})();