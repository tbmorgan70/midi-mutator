{
	"patcher": {
		"fileversion": 1,
		"appversion": {
			"major": 8,
			"minor": 6,
			"revision": 2,
			"architecture": "x64",
			"modernui": 1
		},
		"classnamespace": "box",
		"rect": [ 100.0, 100.0, 760.0, 480.0 ],
		"openinpresentation": 0,
		"boxes": [
			{
				"box": {
					"id": "obj-100",
					"maxclass": "comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [ 30.0, 10.0, 560.0, 20.0 ],
					"text": "MIDI Mutator v1 — select a Session MIDI clip, press Mutate. Variations fill empty slots below."
				}
			},
			{
				"box": {
					"id": "obj-101",
					"maxclass": "live.comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [ 30.0, 420.0, 120.0, 18.0 ],
					"presentation": 1,
					"presentation_rect": [ 8.0, 6.0, 150.0, 18.0 ],
					"text": "MIDI MUTATOR"
				}
			},
			{
				"box": {
					"id": "obj-1",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [ "int" ],
					"patching_rect": [ 30.0, 50.0, 45.0, 22.0 ],
					"text": "midiin"
				}
			},
			{
				"box": {
					"id": "obj-2",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [ 30.0, 90.0, 50.0, 22.0 ],
					"text": "midiout"
				}
			},
			{
				"box": {
					"id": "obj-11",
					"maxclass": "live.dial",
					"varname": "amount_dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [ "", "float" ],
					"parameter_enable": 1,
					"patching_rect": [ 150.0, 150.0, 44.0, 48.0 ],
					"presentation": 1,
					"presentation_rect": [ 8.0, 30.0, 44.0, 48.0 ],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_initial": [ 50.0 ],
							"parameter_initial_enable": 1,
							"parameter_longname": "Amount",
							"parameter_mmax": 100.0,
							"parameter_mmin": 0.0,
							"parameter_shortname": "Amount",
							"parameter_type": 0,
							"parameter_unitstyle": 5
						}
					}
				}
			},
			{
				"box": {
					"id": "obj-12",
					"maxclass": "live.dial",
					"varname": "drift_dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [ "", "float" ],
					"parameter_enable": 1,
					"patching_rect": [ 210.0, 150.0, 44.0, 48.0 ],
					"presentation": 1,
					"presentation_rect": [ 56.0, 30.0, 44.0, 48.0 ],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_initial": [ 2 ],
							"parameter_initial_enable": 1,
							"parameter_longname": "Pitch Drift",
							"parameter_mmax": 7,
							"parameter_mmin": 1,
							"parameter_shortname": "Drift",
							"parameter_type": 1,
							"parameter_unitstyle": 0
						}
					}
				}
			},
			{
				"box": {
					"id": "obj-13",
					"maxclass": "live.dial",
					"varname": "delete_dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [ "", "float" ],
					"parameter_enable": 1,
					"patching_rect": [ 270.0, 150.0, 44.0, 48.0 ],
					"presentation": 1,
					"presentation_rect": [ 104.0, 30.0, 44.0, 48.0 ],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_initial": [ 10.0 ],
							"parameter_initial_enable": 1,
							"parameter_longname": "Delete",
							"parameter_mmax": 100.0,
							"parameter_mmin": 0.0,
							"parameter_shortname": "Delete",
							"parameter_type": 0,
							"parameter_unitstyle": 5
						}
					}
				}
			},
			{
				"box": {
					"id": "obj-14",
					"maxclass": "live.dial",
					"varname": "add_dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [ "", "float" ],
					"parameter_enable": 1,
					"patching_rect": [ 330.0, 150.0, 44.0, 48.0 ],
					"presentation": 1,
					"presentation_rect": [ 152.0, 30.0, 44.0, 48.0 ],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_initial": [ 10.0 ],
							"parameter_initial_enable": 1,
							"parameter_longname": "Add",
							"parameter_mmax": 100.0,
							"parameter_mmin": 0.0,
							"parameter_shortname": "Add",
							"parameter_type": 0,
							"parameter_unitstyle": 5
						}
					}
				}
			},
			{
				"box": {
					"id": "obj-15",
					"maxclass": "live.dial",
					"varname": "timing_dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [ "", "float" ],
					"parameter_enable": 1,
					"patching_rect": [ 390.0, 150.0, 44.0, 48.0 ],
					"presentation": 1,
					"presentation_rect": [ 200.0, 30.0, 44.0, 48.0 ],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_initial": [ 0.0 ],
							"parameter_initial_enable": 1,
							"parameter_longname": "Timing",
							"parameter_mmax": 100.0,
							"parameter_mmin": 0.0,
							"parameter_shortname": "Timing",
							"parameter_type": 0,
							"parameter_unitstyle": 5
						}
					}
				}
			},
			{
				"box": {
					"id": "obj-16",
					"maxclass": "live.dial",
					"varname": "vars_dial",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [ "", "float" ],
					"parameter_enable": 1,
					"patching_rect": [ 450.0, 150.0, 44.0, 48.0 ],
					"presentation": 1,
					"presentation_rect": [ 248.0, 30.0, 44.0, 48.0 ],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_initial": [ 4 ],
							"parameter_initial_enable": 1,
							"parameter_longname": "Variations",
							"parameter_mmax": 8,
							"parameter_mmin": 1,
							"parameter_shortname": "Vars",
							"parameter_type": 1,
							"parameter_unitstyle": 0
						}
					}
				}
			},
			{
				"box": {
					"id": "obj-17",
					"maxclass": "live.numbox",
					"varname": "seed_num",
					"numinlets": 1,
					"numoutlets": 2,
					"outlettype": [ "", "float" ],
					"parameter_enable": 1,
					"patching_rect": [ 510.0, 150.0, 48.0, 15.0 ],
					"presentation": 1,
					"presentation_rect": [ 296.0, 48.0, 48.0, 15.0 ],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_initial": [ 0 ],
							"parameter_initial_enable": 1,
							"parameter_longname": "Seed",
							"parameter_mmax": 99999,
							"parameter_mmin": 0,
							"parameter_shortname": "Seed",
							"parameter_type": 1,
							"parameter_unitstyle": 0
						}
					}
				}
			},
			{
				"box": {
					"id": "obj-102",
					"maxclass": "live.comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [ 510.0, 130.0, 40.0, 18.0 ],
					"presentation": 1,
					"presentation_rect": [ 296.0, 30.0, 48.0, 18.0 ],
					"text": "Seed"
				}
			},
			{
				"box": {
					"id": "obj-30",
					"maxclass": "live.button",
					"varname": "mutate_button",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [ "bang" ],
					"parameter_enable": 1,
					"patching_rect": [ 30.0, 150.0, 24.0, 24.0 ],
					"presentation": 1,
					"presentation_rect": [ 360.0, 34.0, 28.0, 28.0 ],
					"saved_attribute_attributes": {
						"valueof": {
							"parameter_longname": "Mutate",
							"parameter_shortname": "Mutate"
						}
					}
				}
			},
			{
				"box": {
					"id": "obj-103",
					"maxclass": "live.comment",
					"numinlets": 1,
					"numoutlets": 0,
					"patching_rect": [ 60.0, 152.0, 50.0, 18.0 ],
					"presentation": 1,
					"presentation_rect": [ 352.0, 64.0, 50.0, 18.0 ],
					"text": "Mutate"
				}
			},
			{
				"box": {
					"id": "obj-31",
					"maxclass": "message",
					"numinlets": 2,
					"numoutlets": 1,
					"outlettype": [ "" ],
					"patching_rect": [ 30.0, 190.0, 50.0, 22.0 ],
					"text": "mutate"
				}
			},
			{
				"box": {
					"id": "obj-32",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [ "" ],
					"patching_rect": [ 30.0, 230.0, 55.0, 22.0 ],
					"text": "deferlow"
				}
			},
			{
				"box": {
					"id": "obj-21",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [ "" ],
					"patching_rect": [ 150.0, 230.0, 100.0, 22.0 ],
					"text": "prepend amount"
				}
			},
			{
				"box": {
					"id": "obj-22",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [ "" ],
					"patching_rect": [ 260.0, 230.0, 85.0, 22.0 ],
					"text": "prepend drift"
				}
			},
			{
				"box": {
					"id": "obj-23",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [ "" ],
					"patching_rect": [ 355.0, 230.0, 100.0, 22.0 ],
					"text": "prepend delprob"
				}
			},
			{
				"box": {
					"id": "obj-24",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [ "" ],
					"patching_rect": [ 465.0, 230.0, 100.0, 22.0 ],
					"text": "prepend addprob"
				}
			},
			{
				"box": {
					"id": "obj-25",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [ "" ],
					"patching_rect": [ 575.0, 230.0, 95.0, 22.0 ],
					"text": "prepend timing"
				}
			},
			{
				"box": {
					"id": "obj-26",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [ "" ],
					"patching_rect": [ 150.0, 270.0, 115.0, 22.0 ],
					"text": "prepend variations"
				}
			},
			{
				"box": {
					"id": "obj-27",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [ "" ],
					"patching_rect": [ 275.0, 270.0, 90.0, 22.0 ],
					"text": "prepend seed"
				}
			},
			{
				"box": {
					"id": "obj-3",
					"maxclass": "newobj",
					"numinlets": 1,
					"numoutlets": 1,
					"outlettype": [ "" ],
					"patching_rect": [ 150.0, 330.0, 100.0, 22.0 ],
					"saved_object_attributes": {
						"filename": "mutator.js",
						"parameter_enable": 0
					},
					"text": "v8 mutator.js"
				}
			}
		],
		"lines": [
			{ "patchline": { "source": [ "obj-1", 0 ], "destination": [ "obj-2", 0 ] } },
			{ "patchline": { "source": [ "obj-11", 0 ], "destination": [ "obj-21", 0 ] } },
			{ "patchline": { "source": [ "obj-21", 0 ], "destination": [ "obj-3", 0 ] } },
			{ "patchline": { "source": [ "obj-12", 0 ], "destination": [ "obj-22", 0 ] } },
			{ "patchline": { "source": [ "obj-22", 0 ], "destination": [ "obj-3", 0 ] } },
			{ "patchline": { "source": [ "obj-13", 0 ], "destination": [ "obj-23", 0 ] } },
			{ "patchline": { "source": [ "obj-23", 0 ], "destination": [ "obj-3", 0 ] } },
			{ "patchline": { "source": [ "obj-14", 0 ], "destination": [ "obj-24", 0 ] } },
			{ "patchline": { "source": [ "obj-24", 0 ], "destination": [ "obj-3", 0 ] } },
			{ "patchline": { "source": [ "obj-15", 0 ], "destination": [ "obj-25", 0 ] } },
			{ "patchline": { "source": [ "obj-25", 0 ], "destination": [ "obj-3", 0 ] } },
			{ "patchline": { "source": [ "obj-16", 0 ], "destination": [ "obj-26", 0 ] } },
			{ "patchline": { "source": [ "obj-26", 0 ], "destination": [ "obj-3", 0 ] } },
			{ "patchline": { "source": [ "obj-17", 0 ], "destination": [ "obj-27", 0 ] } },
			{ "patchline": { "source": [ "obj-27", 0 ], "destination": [ "obj-3", 0 ] } },
			{ "patchline": { "source": [ "obj-30", 0 ], "destination": [ "obj-31", 0 ] } },
			{ "patchline": { "source": [ "obj-31", 0 ], "destination": [ "obj-32", 0 ] } },
			{ "patchline": { "source": [ "obj-32", 0 ], "destination": [ "obj-3", 0 ] } }
		]
	}
}
