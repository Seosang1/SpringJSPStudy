/*! jQuery Fancytree Plugin */
(function(factory) {
    if (typeof define === "function" && define.amd) {
        define(["jquery"], factory);
    } else {
        factory(jQuery);
    }
}(function($) {

    ! function(a, b, c, d) {
        "use strict";

        function e(b, c) {
            b || (c = c ? ": " + c : "", a.error("Fancytree assertion failed" + c))
        }

        function f(a, c) {
            var d, e, f = b.console ? b.console[a] : null;
            if (f) try {
                f.apply(b.console, c)
            } catch (g) {
                for (e = "", d = 0; d < c.length; d++) e += c[d];
                f(e)
            }
        }

        function g(a) {
            return !(!a.tree || a.statusNodeType === d)
        }

        function h(b, c, d, e) {
            var f, g, h, i = a.map(a.trim(b).split("."), function(a) {
                    return parseInt(a, 10)
                }),
                j = a.map(Array.prototype.slice.call(arguments, 1), function(a) {
                    return parseInt(a, 10)
                });
            for (f = 0; f < j.length; f++)
                if (g = i[f] || 0, h = j[f] || 0, g !== h) return g > h;
            return !0
        }

        function i(a, b, c, d, e) {
            var f = function() {
                var c = b[a],
                    f = d[a],
                    g = b.ext[e],
                    h = function() {
                        return c.apply(b, arguments)
                    },
                    i = function(a) {
                        return c.apply(b, a)
                    };
                return function() {
                    var a = b._local,
                        c = b._super,
                        d = b._superApply;
                    try {
                        return b._local = g, b._super = h, b._superApply = i, f.apply(b, arguments)
                    } finally {
                        b._local = a, b._super = c, b._superApply = d
                    }
                }
            }();
            return f
        }

        function j(b, c, d, e) {
            for (var f in d) "function" == typeof d[f] ? "function" == typeof b[f] ? b[f] = i(f, b, c, d, e) : "_" === f.charAt(0) ? b.ext[e][f] = i(f, b, c, d, e) : a.error("Could not override tree." + f + ". Use prefix '_' to create tree." + e + "._" + f) : "options" !== f && (b.ext[e][f] = d[f])
        }

        function k(b, c) {
            return b === d ? a.Deferred(function() {
                this.resolve()
            }).promise() : a.Deferred(function() {
                this.resolveWith(b, c)
            }).promise()
        }

        function l(b, c) {
            return b === d ? a.Deferred(function() {
                this.reject()
            }).promise() : a.Deferred(function() {
                this.rejectWith(b, c)
            }).promise()
        }

        function m(a, b) {
            return function() {
                a.resolveWith(b)
            }
        }

        function n(b) {
            var c = a.extend({}, b.data()),
                d = c.json;
            return delete c.fancytree, delete c.uiFancytree, d && (delete c.json, c = a.extend(c, d)), c
        }

        function o(a) {
            return ("" + a).replace(y, function(a) {
                return B[a]
            })
        }

        function p(a) {
            return ("" + a).replace(z, function(a) {
                return B[a]
            })
        }

        function q(a) {
            return a = a.toLowerCase(),
                function(b) {
                    return b.title.toLowerCase().indexOf(a) >= 0
                }
        }

        function r(a) {
            var b = new RegExp("^" + a, "i");
            return function(a) {
                return b.test(a.title)
            }
        }

        function s(b, c) {
            var d, f, g, h;
            for (this.parent = b, this.tree = b.tree, this.ul = null, this.li = null, this.statusNodeType = null, this._isLoading = !1, this._error = null, this.data = {}, d = 0, f = H.length; d < f; d++) g = H[d], this[g] = c[g];
            c.data && a.extend(this.data, c.data);
            for (g in c) I[g] || a.isFunction(c[g]) || K[g] || (this.data[g] = c[g]);
            null == this.key ? this.tree.options.defaultKey ? (this.key = this.tree.options.defaultKey(this), e(this.key, "defaultKey() must return a unique key")) : this.key = "_" + w._nextNodeKey++ : this.key = "" + this.key, c.active && (e(null === this.tree.activeNode, "only one active node allowed"), this.tree.activeNode = this), c.selected && (this.tree.lastSelectedNode = this), h = c.children, h ? h.length ? this._setChildren(h) : this.children = this.lazy ? [] : null : this.children = null, this.tree._callHook("treeRegisterNode", this.tree, !0, this)
        }

        function t(b) {
            this.widget = b, this.$div = b.element, this.options = b.options, this.options && (a.isFunction(this.options.lazyload) && !a.isFunction(this.options.lazyLoad) && (this.options.lazyLoad = function() {
                return w.warn("The 'lazyload' event is deprecated since 2014-02-25. Use 'lazyLoad' (with uppercase L) instead."), b.options.lazyload.apply(this, arguments)
            }), a.isFunction(this.options.loaderror) && a.error("The 'loaderror' event was renamed since 2014-07-03. Use 'loadError' (with uppercase E) instead."), this.options.fx !== d && w.warn("The 'fx' option was replaced by 'toggleEffect' since 2014-11-30."), this.options.removeNode !== d && a.error("The 'removeNode' event was replaced by 'modifyChild' since 2.20 (2016-09-10).")), this.ext = {}, this.data = n(this.$div), this._id = a.ui.fancytree._nextId++, this._ns = ".fancytree-" + this._id, this.activeNode = null, this.focusNode = null, this._hasFocus = null, this._enableUpdate = !0, this.lastSelectedNode = null, this.systemFocusElement = null, this.lastQuicksearchTerm = "", this.lastQuicksearchTime = 0, this.statusClassPropName = "span", this.ariaPropName = "li", this.nodeContainerAttrName = "li", this.$div.find(">ul.fancytree-container").remove();
            var c, e = {
                tree: this
            };
            this.rootNode = new s(e, {
                title: "root",
                key: "root_" + this._id,
                children: null,
                expanded: !0
            }), this.rootNode.parent = null, c = a("<ul>", {
                "class": "ui-fancytree fancytree-container fancytree-plain"
            }).appendTo(this.$div), this.$container = c, this.rootNode.ul = c[0], null == this.options.debugLevel && (this.options.debugLevel = w.debugLevel)
        }
        if (a.ui && a.ui.fancytree) return void a.ui.fancytree.warn("Fancytree: ignored duplicate include");
        var u, v, w = null,
            x = new RegExp(/\.|\//),
            y = /[&<>"'\/]/g,
            z = /[<>"'\/]/g,
            A = "$recursive_request",
            B = {
                "&": "&amp;",
                "<": "&lt;",
                ">": "&gt;",
                '"': "&quot;",
                "'": "&#39;",
                "/": "&#x2F;"
            },
            C = {
                16: !0,
                17: !0,
                18: !0
            },
            D = {
                8: "backspace",
                9: "tab",
                10: "return",
                13: "return",
                19: "pause",
                20: "capslock",
                27: "esc",
                32: "space",
                33: "pageup",
                34: "pagedown",
                35: "end",
                36: "home",
                37: "left",
                38: "up",
                39: "right",
                40: "down",
                45: "insert",
                46: "del",
                59: ";",
                61: "=",
                96: "0",
                97: "1",
                98: "2",
                99: "3",
                100: "4",
                101: "5",
                102: "6",
                103: "7",
                104: "8",
                105: "9",
                106: "*",
                107: "+",
                109: "-",
                110: ".",
                111: "/",
                112: "f1",
                113: "f2",
                114: "f3",
                115: "f4",
                116: "f5",
                117: "f6",
                118: "f7",
                119: "f8",
                120: "f9",
                121: "f10",
                122: "f11",
                123: "f12",
                144: "numlock",
                145: "scroll",
                173: "-",
                186: ";",
                187: "=",
                188: ",",
                189: "-",
                190: ".",
                191: "/",
                192: "`",
                219: "[",
                220: "\\",
                221: "]",
                222: "'"
            },
            E = {
                0: "",
                1: "left",
                2: "middle",
                3: "right"
            },
            F = "active expanded focus folder hideCheckbox lazy selected unselectable".split(" "),
            G = {},
            H = "expanded extraClasses folder hideCheckbox icon key lazy refKey selected statusNodeType title tooltip unselectable".split(" "),
            I = {},
            J = {},
            K = {
                active: !0,
                children: !0,
                data: !0,
                focus: !0
            };
        for (u = 0; u < F.length; u++) G[F[u]] = !0;
        for (u = 0; u < H.length; u++) v = H[u], I[v] = !0, v !== v.toLowerCase() && (J[v.toLowerCase()] = v);
        e(a.ui, "Fancytree requires jQuery UI (http://jqueryui.com)"), s.prototype = {
            _findDirectChild: function(a) {
                var b, c, d = this.children;
                if (d)
                    if ("string" == typeof a) {
                        for (b = 0, c = d.length; b < c; b++)
                            if (d[b].key === a) return d[b]
                    } else {
                        if ("number" == typeof a) return this.children[a];
                        if (a.parent === this) return a
                    } return null
            },
            _setChildren: function(a) {
                e(a && (!this.children || 0 === this.children.length), "only init supported"), this.children = [];
                for (var b = 0, c = a.length; b < c; b++) this.children.push(new s(this, a[b]))
            },
            addChildren: function(b, c) {
                var d, f, g, h = this.getFirstChild(),
                    i = this.getLastChild(),
                    j = null,
                    k = [];
                for (a.isPlainObject(b) && (b = [b]), this.children || (this.children = []), d = 0, f = b.length; d < f; d++) k.push(new s(this, b[d]));
                if (j = k[0], null == c ? this.children = this.children.concat(k) : (c = this._findDirectChild(c), g = a.inArray(c, this.children), e(g >= 0, "insertBefore must be an existing child"), this.children.splice.apply(this.children, [g, 0].concat(k))), h && !c) {
                    for (d = 0, f = k.length; d < f; d++) k[d].render();
                    h !== this.getFirstChild() && h.renderStatus(), i !== this.getLastChild() && i.renderStatus()
                } else(!this.parent || this.parent.ul || this.tr) && this.render();
                return 3 === this.tree.options.selectMode && this.fixSelection3FromEndNodes(), this.triggerModifyChild("add", 1 === k.length ? k[0] : null), j
            },
            addClass: function(a) {
                return this.toggleClass(a, !0)
            },
            addNode: function(a, b) {
                switch (b !== d && "over" !== b || (b = "child"), b) {
                    case "after":
                        return this.getParent().addChildren(a, this.getNextSibling());
                    case "before":
                        return this.getParent().addChildren(a, this);
                    case "firstChild":
                        var c = this.children ? this.children[0] : null;
                        return this.addChildren(a, c);
                    case "child":
                    case "over":
                        return this.addChildren(a)
                }
                e(!1, "Invalid mode: " + b)
            },
            addPagingNode: function(b, c) {
                var d, e;
                if (c = c || "child", b === !1) {
                    for (d = this.children.length - 1; d >= 0; d--) e = this.children[d], "paging" === e.statusNodeType && this.removeChild(e);
                    return void(this.partload = !1)
                }
                return b = a.extend({
                    title: this.tree.options.strings.moreData,
                    statusNodeType: "paging",
                    icon: !1
                }, b), this.partload = !0, this.addNode(b, c)
            },
            appendSibling: function(a) {
                return this.addNode(a, "after")
            },
            applyPatch: function(b) {
                if (null === b) return this.remove(), k(this);
                var c, d, e, f = {
                    children: !0,
                    expanded: !0,
                    parent: !0
                };
                for (c in b) e = b[c], f[c] || a.isFunction(e) || (I[c] ? this[c] = e : this.data[c] = e);
                return b.hasOwnProperty("children") && (this.removeChildren(), b.children && this._setChildren(b.children)), this.isVisible() && (this.renderTitle(), this.renderStatus()), d = b.hasOwnProperty("expanded") ? this.setExpanded(b.expanded) : k(this)
            },
            collapseSiblings: function() {
                return this.tree._callHook("nodeCollapseSiblings", this)
            },
            copyTo: function(a, b, c) {
                return a.addNode(this.toDict(!0, c), b)
            },
            countChildren: function(a) {
                var b, c, d, e = this.children;
                if (!e) return 0;
                if (d = e.length, a !== !1)
                    for (b = 0, c = d; b < c; b++) d += e[b].countChildren();
                return d
            },
            debug: function(a) {
                this.tree.options.debugLevel >= 2 && (Array.prototype.unshift.call(arguments, this.toString()), f("log", arguments))
            },
            discard: function() {
                return this.warn("FancytreeNode.discard() is deprecated since 2014-02-16. Use .resetLazy() instead."), this.resetLazy()
            },
            discardMarkup: function(a) {
                var b = a ? "nodeRemoveMarkup" : "nodeRemoveChildMarkup";
                this.tree._callHook(b, this)
            },
            findAll: function(b) {
                b = a.isFunction(b) ? b : q(b);
                var c = [];
                return this.visit(function(a) {
                    b(a) && c.push(a)
                }), c
            },
            findFirst: function(b) {
                b = a.isFunction(b) ? b : q(b);
                var c = null;
                return this.visit(function(a) {
                    if (b(a)) return c = a, !1
                }), c
            },
            _changeSelectStatusAttrs: function(a) {
                var b = !1;
                switch (a) {
                    case !1:
                        b = this.selected || this.partsel, this.selected = !1, this.partsel = !1;
                        break;
                    case !0:
                        b = !this.selected || !this.partsel, this.selected = !0, this.partsel = !0;
                        break;
                    case d:
                        b = this.selected || !this.partsel, this.selected = !1, this.partsel = !0;
                        break;
                    default:
                        e(!1, "invalid state: " + a)
                }
                return b && this.renderStatus(), b
            },
            fixSelection3AfterClick: function() {
                var a = this.isSelected();
                this.visit(function(b) {
                    b._changeSelectStatusAttrs(a)
                }), this.fixSelection3FromEndNodes()
            },
            fixSelection3FromEndNodes: function() {
                function a(b) {
                    var c, e, f, g, h, i, j, k = b.children;
                    if (k && k.length) {
                        for (i = !0, j = !1, c = 0, e = k.length; c < e; c++) f = k[c], g = a(f), g !== !1 && (j = !0), g !== !0 && (i = !1);
                        h = !!i || !!j && d
                    } else h = !!b.selected;
                    return b._changeSelectStatusAttrs(h), h
                }
                e(3 === this.tree.options.selectMode, "expected selectMode 3"), a(this), this.visitParents(function(a) {
                    var b, c, e, f, g = a.children,
                        h = !0,
                        i = !1;
                    for (b = 0, c = g.length; b < c; b++) e = g[b], (e.selected || e.partsel) && (i = !0), e.unselectable || e.selected || (h = !1);
                    f = !!h || !!i && d, a._changeSelectStatusAttrs(f)
                })
            },
            fromDict: function(b) {
                for (var c in b) I[c] ? this[c] = b[c] : "data" === c ? a.extend(this.data, b.data) : a.isFunction(b[c]) || K[c] || (this.data[c] = b[c]);
                b.children && (this.removeChildren(), this.addChildren(b.children)), this.renderTitle()
            },
            getChildren: function() {
                return this.hasChildren() === d ? d : this.children
            },
            getFirstChild: function() {
                return this.children ? this.children[0] : null
            },
            getIndex: function() {
                return a.inArray(this, this.parent.children)
            },
            getIndexHier: function(b, c) {
                b = b || ".";
                var d, e = [];
                return a.each(this.getParentList(!1, !0), function(a, b) {
                    d = "" + (b.getIndex() + 1), c && (d = ("0000000" + d).substr(-c)), e.push(d)
                }), e.join(b)
            },
            getKeyPath: function(a) {
                var b = [],
                    c = this.tree.options.keyPathSeparator;
                return this.visitParents(function(a) {
                    a.parent && b.unshift(a.key)
                }, !a), c + b.join(c)
            },
            getLastChild: function() {
                return this.children ? this.children[this.children.length - 1] : null
            },
            getLevel: function() {
                for (var a = 0, b = this.parent; b;) a++, b = b.parent;
                return a
            },
            getNextSibling: function() {
                if (this.parent) {
                    var a, b, c = this.parent.children;
                    for (a = 0, b = c.length - 1; a < b; a++)
                        if (c[a] === this) return c[a + 1]
                }
                return null
            },
            getParent: function() {
                return this.parent
            },
            getParentList: function(a, b) {
                for (var c = [], d = b ? this : this.parent; d;)(a || d.parent) && c.unshift(d), d = d.parent;
                return c
            },
            getPrevSibling: function() {
                if (this.parent) {
                    var a, b, c = this.parent.children;
                    for (a = 1, b = c.length; a < b; a++)
                        if (c[a] === this) return c[a - 1]
                }
                return null
            },
            getSelectedNodes: function(a) {
                var b = [];
                return this.visit(function(c) {
                    if (c.selected && (b.push(c), a === !0)) return "skip"
                }), b
            },
            hasChildren: function() {
                return this.lazy ? null == this.children ? d : 0 !== this.children.length && (1 !== this.children.length || !this.children[0].isStatusNode() || d) : !(!this.children || !this.children.length)
            },
            hasFocus: function() {
                return this.tree.hasFocus() && this.tree.focusNode === this
            },
            info: function(a) {
                this.tree.options.debugLevel >= 1 && (Array.prototype.unshift.call(arguments, this.toString()), f("info", arguments))
            },
            isActive: function() {
                return this.tree.activeNode === this
            },
            isChildOf: function(a) {
                return this.parent && this.parent === a
            },
            isDescendantOf: function(a) {
                if (!a || a.tree !== this.tree) return !1;
                for (var b = this.parent; b;) {
                    if (b === a) return !0;
                    b = b.parent
                }
                return !1
            },
            isExpanded: function() {
                return !!this.expanded
            },
            isFirstSibling: function() {
                var a = this.parent;
                return !a || a.children[0] === this
            },
            isFolder: function() {
                return !!this.folder
            },
            isLastSibling: function() {
                var a = this.parent;
                return !a || a.children[a.children.length - 1] === this
            },
            isLazy: function() {
                return !!this.lazy
            },
            isLoaded: function() {
                return !this.lazy || this.hasChildren() !== d
            },
            isLoading: function() {
                return !!this._isLoading
            },
            isRoot: function() {
                return this.isRootNode()
            },
            isPartload: function() {
                return !!this.partload
            },
            isRootNode: function() {
                return this.tree.rootNode === this
            },
            isSelected: function() {
                return !!this.selected
            },
            isStatusNode: function() {
                return !!this.statusNodeType
            },
            isPagingNode: function() {
                return "paging" === this.statusNodeType
            },
            isTopLevel: function() {
                return this.tree.rootNode === this.parent
            },
            isUndefined: function() {
                return this.hasChildren() === d
            },
            isVisible: function() {
                var a, b, c = this.getParentList(!1, !1);
                for (a = 0, b = c.length; a < b; a++)
                    if (!c[a].expanded) return !1;
                return !0
            },
            lazyLoad: function(a) {
                return this.warn("FancytreeNode.lazyLoad() is deprecated since 2014-02-16. Use .load() instead."), this.load(a)
            },
            load: function(a) {
                var b, c, d = this,
                    f = this.isExpanded();
                return e(this.isLazy(), "load() requires a lazy node"), a || this.isUndefined() ? (this.isLoaded() && this.resetLazy(), c = this.tree._triggerNodeEvent("lazyLoad", this), c === !1 ? k(this) : (e("boolean" != typeof c, "lazyLoad event must return source in data.result"), b = this.tree._callHook("nodeLoadChildren", this, c), f ? (this.expanded = !0, b.always(function() {
                    d.render()
                })) : b.always(function() {
                    d.renderStatus()
                }), b)) : k(this)
            },
            makeVisible: function(b) {
                var c, d = this,
                    e = [],
                    f = new a.Deferred,
                    g = this.getParentList(!1, !1),
                    h = g.length,
                    i = !(b && b.noAnimation === !0),
                    j = !(b && b.scrollIntoView === !1);
                for (c = h - 1; c >= 0; c--) e.push(g[c].setExpanded(!0, b));
                return a.when.apply(a, e).done(function() {
                    j ? d.scrollIntoView(i).done(function() {
                        f.resolve()
                    }) : f.resolve()
                }), f.promise()
            },
            moveTo: function(b, c, f) {
                c === d || "over" === c ? c = "child" : "firstChild" === c && (b.children && b.children.length ? (c = "before", b = b.children[0]) : c = "child");
                var g, h = this.parent,
                    i = "child" === c ? b : b.parent;
                if (this !== b) {
                    if (this.parent ? i.isDescendantOf(this) && a.error("Cannot move a node to its own descendant") : a.error("Cannot move system root"), i !== h && h.triggerModifyChild("remove", this), 1 === this.parent.children.length) {
                        if (this.parent === i) return;
                        this.parent.children = this.parent.lazy ? [] : null, this.parent.expanded = !1
                    } else g = a.inArray(this, this.parent.children), e(g >= 0, "invalid source parent"), this.parent.children.splice(g, 1);
                    if (this.parent = i, i.hasChildren()) switch (c) {
                        case "child":
                            i.children.push(this);
                            break;
                        case "before":
                            g = a.inArray(b, i.children), e(g >= 0, "invalid target parent"), i.children.splice(g, 0, this);
                            break;
                        case "after":
                            g = a.inArray(b, i.children), e(g >= 0, "invalid target parent"), i.children.splice(g + 1, 0, this);
                            break;
                        default:
                            a.error("Invalid mode " + c)
                    } else i.children = [this];
                    f && b.visit(f, !0), i === h ? i.triggerModifyChild("move", this) : i.triggerModifyChild("add", this), this.tree !== b.tree && (this.warn("Cross-tree moveTo is experimantal!"), this.visit(function(a) {
                        a.tree = b.tree
                    }, !0)), h.isDescendantOf(i) || h.render(), i.isDescendantOf(h) || i === h || i.render()
                }
            },
            navigate: function(b, c) {
                function d(d) {
                    if (d) {
                        try {
                            d.makeVisible({
                                scrollIntoView: !1
                            })
                        } catch (e) {}
                        return a(d.span).is(":visible") ? c === !1 ? d.setFocus() : d.setActive() : (d.debug("Navigate: skipping hidden node"), void d.navigate(b, c))
                    }
                }
                var e, f, g, h = !0,
                    i = a.ui.keyCode,
                    j = null;
                switch (b) {
                    case i.BACKSPACE:
                        this.parent && this.parent.parent && (g = d(this.parent));
                        break;
                    case i.HOME:
                        this.tree.visit(function(b) {
                            if (a(b.span).is(":visible")) return g = d(b), !1
                        });
                        break;
                    case i.END:
                        this.tree.visit(function(b) {
                            a(b.span).is(":visible") && (g = b)
                        }), g && (g = d(g));
                        break;
                    case i.LEFT:
                        this.expanded ? (this.setExpanded(!1), g = d(this)) : this.parent && this.parent.parent && (g = d(this.parent));
                        break;
                    case i.RIGHT:
                        this.expanded || !this.children && !this.lazy ? this.children && this.children.length && (g = d(this.children[0])) : (this.setExpanded(), g = d(this));
                        break;
                    case i.UP:
                        for (j = this.getPrevSibling(); j && !a(j.span).is(":visible");) j = j.getPrevSibling();
                        for (; j && j.expanded && j.children && j.children.length;) j = j.children[j.children.length - 1];
                        !j && this.parent && this.parent.parent && (j = this.parent), g = d(j);
                        break;
                    case i.DOWN:
                        if (this.expanded && this.children && this.children.length) j = this.children[0];
                        else
                            for (f = this.getParentList(!1, !0), e = f.length - 1; e >= 0; e--) {
                                for (j = f[e].getNextSibling(); j && !a(j.span).is(":visible");) j = j.getNextSibling();
                                if (j) break
                            }
                        g = d(j);
                        break;
                    default:
                        h = !1
                }
                return g || k()
            },
            remove: function() {
                return this.parent.removeChild(this)
            },
            removeChild: function(a) {
                return this.tree._callHook("nodeRemoveChild", this, a)
            },
            removeChildren: function() {
                return this.tree._callHook("nodeRemoveChildren", this)
            },
            removeClass: function(a) {
                return this.toggleClass(a, !1)
            },
            render: function(a, b) {
                return this.tree._callHook("nodeRender", this, a, b)
            },
            renderTitle: function() {
                return this.tree._callHook("nodeRenderTitle", this)
            },
            renderStatus: function() {
                return this.tree._callHook("nodeRenderStatus", this)
            },
            replaceWith: function(b) {
                var c, d = this.parent,
                    f = a.inArray(this, d.children),
                    g = this;
                return e(this.isPagingNode(), "replaceWith() currently requires a paging status node"), c = this.tree._callHook("nodeLoadChildren", this, b), c.done(function(a) {
                    var b = g.children;
                    for (u = 0; u < b.length; u++) b[u].parent = d;
                    d.children.splice.apply(d.children, [f + 1, 0].concat(b)), g.children = null, g.remove(), d.render()
                }).fail(function() {
                    g.setExpanded()
                }), c
            },
            resetLazy: function() {
                this.removeChildren(), this.expanded = !1, this.lazy = !0, this.children = d, this.renderStatus()
            },
            scheduleAction: function(b, c) {
                this.tree.timer && clearTimeout(this.tree.timer), this.tree.timer = null;
                var d = this;
                switch (b) {
                    case "cancel":
                        break;
                    case "expand":
                        this.tree.timer = setTimeout(function() {
                            d.tree.debug("setTimeout: trigger expand"), d.setExpanded(!0)
                        }, c);
                        break;
                    case "activate":
                        this.tree.timer = setTimeout(function() {
                            d.tree.debug("setTimeout: trigger activate"), d.setActive(!0)
                        }, c);
                        break;
                    default:
                        a.error("Invalid mode " + b)
                }
            },
            scrollIntoView: function(f, h) {
                h !== d && g(h) && (this.warn("scrollIntoView() with 'topNode' option is deprecated since 2014-05-08. Use 'options.topNode' instead."), h = {
                    topNode: h
                });
                var i, j, l, m, n = a.extend({
                        effects: f === !0 ? {
                            duration: 200,
                            queue: !1
                        } : f,
                        scrollOfs: this.tree.options.scrollOfs,
                        scrollParent: this.tree.options.scrollParent || this.tree.$container,
                        topNode: null
                    }, h),
                    o = new a.Deferred,
                    p = this,
                    q = a(this.span).height(),
                    r = a(n.scrollParent),
                    s = n.scrollOfs.top || 0,
                    t = n.scrollOfs.bottom || 0,
                    u = r.height(),
                    v = r.scrollTop(),
                    w = r,
                    x = r[0] === b,
                    y = n.topNode || null,
                    z = null;
                return a(this.span).is(":visible") ? (x ? (j = a(this.span).offset().top, i = y && y.span ? a(y.span).offset().top : 0, w = a("html,body")) : (e(r[0] !== c && r[0] !== c.body, "scrollParent should be a simple element or `window`, not document or body."), m = r.offset().top, j = a(this.span).offset().top - m + v, i = y ? a(y.span).offset().top - m + v : 0, l = Math.max(0, r.innerHeight() - r[0].clientHeight), u -= l), j < v + s ? z = j - s : j + q > v + u - t && (z = j + q - u + t, y && (e(y.isRootNode() || a(y.span).is(":visible"), "topNode must be visible"), i < z && (z = i - s))), null !== z ? n.effects ? (n.effects.complete = function() {
                    o.resolveWith(p)
                }, w.stop(!0).animate({
                    scrollTop: z
                }, n.effects)) : (w[0].scrollTop = z, o.resolveWith(this)) : o.resolveWith(this), o.promise()) : (this.warn("scrollIntoView(): node is invisible."), k())
            },
            setActive: function(a, b) {
                return this.tree._callHook("nodeSetActive", this, a, b)
            },
            setExpanded: function(a, b) {
                return this.tree._callHook("nodeSetExpanded", this, a, b)
            },
            setFocus: function(a) {
                return this.tree._callHook("nodeSetFocus", this, a)
            },
            setSelected: function(a) {
                return this.tree._callHook("nodeSetSelected", this, a)
            },
            setStatus: function(a, b, c) {
                return this.tree._callHook("nodeSetStatus", this, a, b, c)
            },
            setTitle: function(a) {
                this.title = a, this.renderTitle(), this.triggerModify("rename")
            },
            sortChildren: function(a, b) {
                var c, d, e = this.children;
                if (e) {
                    if (a = a || function(a, b) {
                            var c = a.title.toLowerCase(),
                                d = b.title.toLowerCase();
                            return c === d ? 0 : c > d ? 1 : -1
                        }, e.sort(a), b)
                        for (c = 0, d = e.length; c < d; c++) e[c].children && e[c].sortChildren(a, "$norender$");
                    "$norender$" !== b && this.render(), this.triggerModifyChild("sort")
                }
            },
            toDict: function(b, c) {
                var d, e, f, g = {},
                    h = this;
                if (a.each(H, function(a, b) {
                        (h[b] || h[b] === !1) && (g[b] = h[b])
                    }), a.isEmptyObject(this.data) || (g.data = a.extend({}, this.data), a.isEmptyObject(g.data) && delete g.data), c && c(g, h), b && this.hasChildren())
                    for (g.children = [], d = 0, e = this.children.length; d < e; d++) f = this.children[d], f.isStatusNode() || g.children.push(f.toDict(!0, c));
                return g
            },
            toggleClass: function(b, c) {
                var e, f, g = /\S+/g,
                    h = b.match(g) || [],
                    i = 0,
                    j = !1,
                    k = this[this.tree.statusClassPropName],
                    l = " " + (this.extraClasses || "") + " ";
                for (k && a(k).toggleClass(b, c); e = h[i++];)
                    if (f = l.indexOf(" " + e + " ") >= 0, c = c === d ? !f : !!c) f || (l += e + " ", j = !0);
                    else
                        for (; l.indexOf(" " + e + " ") > -1;) l = l.replace(" " + e + " ", " ");
                return this.extraClasses = a.trim(l), j
            },
            toggleExpanded: function() {
                return this.tree._callHook("nodeToggleExpanded", this)
            },
            toggleSelected: function() {
                return this.tree._callHook("nodeToggleSelected", this)
            },
            toString: function() {
                return "<FancytreeNode(#" + this.key + ", '" + this.title + "')>"
            },
            triggerModifyChild: function(b, c, d) {
                var e, f = this.tree.options.modifyChild;
                f && (c && c.parent !== this && a.error("childNode " + c + " is not a child of " + this), e = {
                    node: this,
                    tree: this.tree,
                    operation: b,
                    childNode: c || null
                }, d && a.extend(e, d), f({
                    type: "modifyChild"
                }, e))
            },
            triggerModify: function(a, b) {
                this.parent.triggerModifyChild(a, this, b)
            },
            visit: function(a, b) {
                var c, d, e = !0,
                    f = this.children;
                if (b === !0 && (e = a(this), e === !1 || "skip" === e)) return e;
                if (f)
                    for (c = 0, d = f.length; c < d && (e = f[c].visit(a, !0), e !== !1); c++);
                return e
            },
            visitAndLoad: function(b, c, d) {
                var e, f, g, h = this;
                return b && c === !0 && (f = b(h), f === !1 || "skip" === f) ? d ? f : k() : h.children || h.lazy ? (e = new a.Deferred, g = [], h.load().done(function() {
                    for (var c = 0, d = h.children.length; c < d; c++) {
                        if (f = h.children[c].visitAndLoad(b, !0, !0), f === !1) {
                            e.reject();
                            break
                        }
                        "skip" !== f && g.push(f)
                    }
                    a.when.apply(this, g).then(function() {
                        e.resolve()
                    })
                }), e.promise()) : k()
            },
            visitParents: function(a, b) {
                if (b && a(this) === !1) return !1;
                for (var c = this.parent; c;) {
                    if (a(c) === !1) return !1;
                    c = c.parent
                }
                return !0
            },
            warn: function(a) {
                Array.prototype.unshift.call(arguments, this.toString()), f("warn", arguments)
            }
        }, t.prototype = {
            _makeHookContext: function(b, c, e) {
                var f, g;
                return b.node !== d ? (c && b.originalEvent !== c && a.error("invalid args"), f = b) : b.tree ? (g = b.tree, f = {
                    node: b,
                    tree: g,
                    widget: g.widget,
                    options: g.widget.options,
                    originalEvent: c
                }) : b.widget ? f = {
                    node: null,
                    tree: b,
                    widget: b.widget,
                    options: b.widget.options,
                    originalEvent: c
                } : a.error("invalid args"), e && a.extend(f, e), f
            },
            _callHook: function(b, c, d) {
                var e = this._makeHookContext(c),
                    f = this[b],
                    g = Array.prototype.slice.call(arguments, 2);
                return a.isFunction(f) || a.error("_callHook('" + b + "') is not a function"), g.unshift(e), f.apply(this, g)
            },
            _requireExtension: function(b, c, d, f) {
                d = !!d;
                var g = this._local.name,
                    h = this.options.extensions,
                    i = a.inArray(b, h) < a.inArray(g, h),
                    j = c && null == this.ext[b],
                    k = !j && null != d && d !== i;
                return e(g && g !== b, "invalid or same name"), !j && !k || (f || (j || c ? (f = "'" + g + "' extension requires '" + b + "'", k && (f += " to be registered " + (d ? "before" : "after") + " itself")) : f = "If used together, `" + b + "` must be registered " + (d ? "before" : "after") + " `" + g + "`"), a.error(f), !1)
            },
            activateKey: function(a) {
                var b = this.getNodeByKey(a);
                return b ? b.setActive() : this.activeNode && this.activeNode.setActive(!1), b
            },
            addPagingNode: function(a, b) {
                return this.rootNode.addPagingNode(a, b)
            },
            applyPatch: function(b) {
                var c, d, f, g, h, i, j = b.length,
                    k = [];
                for (d = 0; d < j; d++) f = b[d], e(2 === f.length, "patchList must be an array of length-2-arrays"), g = f[0], h = f[1], i = null === g ? this.rootNode : this.getNodeByKey(g), i ? (c = new a.Deferred, k.push(c), i.applyPatch(h).always(m(c, i))) : this.warn("could not find node with key '" + g + "'");
                return a.when.apply(a, k).promise()
            },
            clear: function(a) {
                this._callHook("treeClear", this)
            },
            count: function() {
                return this.rootNode.countChildren()
            },
            debug: function(a) {
                this.options.debugLevel >= 2 && (Array.prototype.unshift.call(arguments, this.toString()), f("log", arguments))
            },
            enableUpdate: function(a) {
                return a = a !== !1, !!this._enableUpdate == !!a ? a : (this._enableUpdate = a, a ? (this.debug("enableUpdate(true): redraw ", this._dirtyRoots), this.render()) : this.debug("enableUpdate(false)..."), !a)
            },
            findAll: function(a) {
                return this.rootNode.findAll(a)
            },
            findFirst: function(a) {
                return this.rootNode.findFirst(a)
            },
            findNextNode: function(b, c, d) {
                var e = null,
                    f = c.parent.children,
                    g = null,
                    h = function(a, b, c) {
                        var d, e, f = a.children,
                            g = f.length,
                            i = f[b];
                        if (i && c(i) === !1) return !1;
                        if (i && i.children && i.expanded && h(i, 0, c) === !1) return !1;
                        for (d = b + 1; d < g; d++)
                            if (h(a, d, c) === !1) return !1;
                        return e = a.parent, e ? h(e, e.children.indexOf(a) + 1, c) : h(a, 0, c)
                    };
                return b = "string" == typeof b ? r(b) : b, c = c || this.getFirstChild(), h(c.parent, f.indexOf(c), function(d) {
                    return d !== e && (e = e || d, a(d.span).is(":visible") ? (!b(d) || (g = d, g === c)) && void 0 : void d.debug("quicksearch: skipping hidden node"))
                }), g
            },
            generateFormElements: function(b, c, d) {
                function e(b) {
                    j.append(a("<input>", {
                        type: "checkbox",
                        name: g,
                        value: b.key,
                        checked: !0
                    }))
                }
                d = d || {};
                var f, g = "string" == typeof b ? b : "ft_" + this._id + "[]",
                    h = "string" == typeof c ? c : "ft_" + this._id + "_active",
                    i = "fancytree_result_" + this._id,
                    j = a("#" + i),
                    k = 3 === this.options.selectMode && d.stopOnParents !== !1;
                j.length ? j.empty() : j = a("<div>", {
                    id: i
                }).hide().insertAfter(this.$container), c !== !1 && this.activeNode && j.append(a("<input>", {
                    type: "radio",
                    name: h,
                    value: this.activeNode.key,
                    checked: !0
                })), d.filter ? this.visit(function(a) {
                    var b = d.filter(a);
                    return "skip" === b ? b : void(b !== !1 && e(a))
                }) : b !== !1 && (f = this.getSelectedNodes(k), a.each(f, function(a, b) {
                    e(b)
                }))
            },
            getActiveNode: function() {
                return this.activeNode
            },
            getFirstChild: function() {
                return this.rootNode.getFirstChild()
            },
            getFocusNode: function() {
                return this.focusNode
            },
            getNodeByKey: function(a, b) {
                var d, e;
                return !b && (d = c.getElementById(this.options.idPrefix + a)) ? d.ftnode ? d.ftnode : null : (b = b || this.rootNode, e = null, b.visit(function(b) {
                    if (b.key === a) return e = b, !1
                }, !0), e)
            },
            getRootNode: function() {
                return this.rootNode
            },
            getSelectedNodes: function(a) {
                return this.rootNode.getSelectedNodes(a)
            },
            hasFocus: function() {
                return !!this._hasFocus
            },
            info: function(a) {
                this.options.debugLevel >= 1 && (Array.prototype.unshift.call(arguments, this.toString()), f("info", arguments))
            },
            loadKeyPath: function(b, c, e) {
                function f(a, b, d) {
                    c.call(r, b, "loading"), b.load().done(function() {
                        r.loadKeyPath.call(r, l[a], c, b).always(m(d, r))
                    }).fail(function(e) {
                        r.warn("loadKeyPath: error loading: " + a + " (parent: " + o + ")"), c.call(r, b, "error"), d.reject()
                    })
                }
                var g, h, i, j, k, l, n, o, p, q = this.options.keyPathSeparator,
                    r = this;
                for (c = c || a.noop, a.isArray(b) || (b = [b]), l = {}, i = 0; i < b.length; i++)
                    for (o = e || this.rootNode, j = b[i], j.charAt(0) === q && (j = j.substr(1)), p = j.split(q); p.length;) {
                        if (k = p.shift(), n = o._findDirectChild(k), !n) {
                            this.warn("loadKeyPath: key not found: " + k + " (parent: " + o + ")"), c.call(this, k, "error");
                            break
                        }
                        if (0 === p.length) {
                            c.call(this, n, "ok");
                            break
                        }
                        if (n.lazy && n.hasChildren() === d) {
                            c.call(this, n, "loaded"), l[k] ? l[k].push(p.join(q)) : l[k] = [p.join(q)];
                            break
                        }
                        c.call(this, n, "loaded"), o = n
                    }
                g = [];
                for (k in l) n = o._findDirectChild(k), null == n && (n = r.getNodeByKey(k)), h = new a.Deferred, g.push(h), f(k, n, h);
                return a.when.apply(a, g).promise()
            },
            reactivate: function(a) {
                var b, c = this.activeNode;
                return c ? (this.activeNode = null, b = c.setActive(!0, {
                    noFocus: !0
                }), a && c.setFocus(), b) : k()
            },
            reload: function(a) {
                return this._callHook("treeClear", this), this._callHook("treeLoad", this, a)
            },
            render: function(a, b) {
                return this.rootNode.render(a, b)
            },
            setFocus: function(a) {
                return this._callHook("treeSetFocus", this, a)
            },
            toDict: function(a, b) {
                var c = this.rootNode.toDict(!0, b);
                return a ? c : c.children
            },
            toString: function() {
                return "<Fancytree(#" + this._id + ")>"
            },
            _triggerNodeEvent: function(a, b, c, e) {
                var f = this._makeHookContext(b, c, e),
                    g = this.widget._trigger(a, c, f);
                return g !== !1 && f.result !== d ? f.result : g
            },
            _triggerTreeEvent: function(a, b, c) {
                var e = this._makeHookContext(this, b, c),
                    f = this.widget._trigger(a, b, e);
                return f !== !1 && e.result !== d ? e.result : f
            },
            visit: function(a) {
                return this.rootNode.visit(a, !1)
            },
            warn: function(a) {
                Array.prototype.unshift.call(arguments, this.toString()), f("warn", arguments)
            }
        }, a.extend(t.prototype, {
            nodeClick: function(a) {
                var b, c, d = a.targetType,
                    e = a.node;
                if ("expander" === d) {
                    if (e.isLoading()) return void e.debug("Got 2nd click while loading: ignored");
                    this._callHook("nodeToggleExpanded", a)
                } else if ("checkbox" === d) this._callHook("nodeToggleSelected", a), a.options.focusOnSelect && this._callHook("nodeSetFocus", a, !0);
                else {
                    if (c = !1, b = !0, e.folder) switch (a.options.clickFolderMode) {
                        case 2:
                            c = !0, b = !1;
                            break;
                        case 3:
                            b = !0, c = !0
                    }
                    b && (this.nodeSetFocus(a), this._callHook("nodeSetActive", a, !0)), c && this._callHook("nodeToggleExpanded", a)
                }
            },
            nodeCollapseSiblings: function(a, b) {
                var c, d, e, f = a.node;
                if (f.parent)
                    for (c = f.parent.children, d = 0, e = c.length; d < e; d++) c[d] !== f && c[d].expanded && this._callHook("nodeSetExpanded", c[d], !1, b)
            },
            nodeDblclick: function(a) {
                "title" === a.targetType && 4 === a.options.clickFolderMode && this._callHook("nodeToggleExpanded", a), "title" === a.targetType && a.originalEvent.preventDefault()
            },
            nodeKeydown: function(b) {
                var c, d, e, f, g = b.originalEvent,
                    h = b.node,
                    i = b.tree,
                    j = b.options,
                    k = g.which,
                    l = String.fromCharCode(k),
                    m = !(g.altKey || g.ctrlKey || g.metaKey || g.shiftKey),
                    n = a(g.target),
                    o = !0,
                    p = !(g.ctrlKey || !j.autoActivate);
                if (h || (f = this.getActiveNode() || this.getFirstChild(), f && (f.setFocus(), h = b.node = this.focusNode, h.debug("Keydown force focus on active node"))), j.quicksearch && m && /\w/.test(l) && !D[k] && !n.is(":input:enabled")) return d = (new Date).getTime(), d - i.lastQuicksearchTime > 500 && (i.lastQuicksearchTerm = ""), i.lastQuicksearchTime = d, i.lastQuicksearchTerm += l, c = i.findNextNode(i.lastQuicksearchTerm, i.getActiveNode()), c && c.setActive(), void g.preventDefault();
                switch (w.eventToString(g)) {
                    case "+":
                    case "=":
                        i.nodeSetExpanded(b, !0);
                        break;
                    case "-":
                        i.nodeSetExpanded(b, !1);
                        break;
                    case "space":
                        h.isPagingNode() ? i._triggerNodeEvent("clickPaging", b, g) : j.checkbox ? i.nodeToggleSelected(b) : i.nodeSetActive(b, !0);
                        break;
                    case "return":
                        i.nodeSetActive(b, !0);
                        break;
                    case "home":
                    case "end":
                    case "backspace":
                    case "left":
                    case "right":
                    case "up":
                    case "down":
                        e = h.navigate(g.which, p, !0);
                        break;
                    default:
                        o = !1
                }
                o && g.preventDefault()
            },
            nodeLoadChildren: function(b, c) {
                var d, f, g, h = b.tree,
                    i = b.node,
                    j = (new Date).getTime();
                return a.isFunction(c) && (c = c.call(h, {
                    type: "source"
                }, b), e(!a.isFunction(c), "source callback must not return another function")), c.url && (i._requestId && i.warn("Recursive load request #" + j + " while #" + i._requestId + " is pending."), d = a.extend({}, b.options.ajax, c), i._requestId = j, d.debugDelay ? (f = d.debugDelay, a.isArray(f) && (f = f[0] + Math.random() * (f[1] - f[0])), i.warn("nodeLoadChildren waiting debugDelay " + Math.round(f) + " ms ..."), d.debugDelay = !1, g = a.Deferred(function(b) {
                    setTimeout(function() {
                        a.ajax(d).done(function() {
                            b.resolveWith(this, arguments)
                        }).fail(function() {
                            b.rejectWith(this, arguments)
                        })
                    }, f)
                })) : g = a.ajax(d), c = new a.Deferred, g.done(function(d, e, f) {
                    var g, k;
                    if ("json" !== this.dataType && "jsonp" !== this.dataType || "string" != typeof d || a.error("Ajax request returned a string (did you get the JSON dataType wrong?)."), i._requestId && i._requestId > j) return void c.rejectWith(this, [A]);
                    if (b.options.postProcess) {
                        try {
                            k = h._triggerNodeEvent("postProcess", b, b.originalEvent, {
                                response: d,
                                error: null,
                                dataType: this.dataType
                            })
                        } catch (l) {
                            k = {
                                error: l,
                                message: "" + l,
                                details: "postProcess failed"
                            }
                        }
                        if (k.error) return g = a.isPlainObject(k.error) ? k.error : {
                            message: k.error
                        }, g = h._makeHookContext(i, null, g), void c.rejectWith(this, [g]);
                        d = a.isArray(k) ? k : d
                    } else d && d.hasOwnProperty("d") && b.options.enableAspx && (d = "string" == typeof d.d ? a.parseJSON(d.d) : d.d);
                    c.resolveWith(this, [d])
                }).fail(function(a, b, d) {
                    var e = h._makeHookContext(i, null, {
                        error: a,
                        args: Array.prototype.slice.call(arguments),
                        message: d,
                        details: a.status + ": " + d
                    });
                    c.rejectWith(this, [e])
                })), a.isFunction(c.then) && a.isFunction(c["catch"]) && (g = c, c = new a.Deferred, g.then(function(a) {
                    c.resolve(a)
                }, function(a) {
                    c.reject(a)
                })), a.isFunction(c.promise) && (h.nodeSetStatus(b, "loading"), c.done(function(a) {
                    h.nodeSetStatus(b, "ok"), i._requestId = null
                }).fail(function(a) {
                    var c;
                    return a === A ? void i.warn("Ignored response for obsolete load request #" + j + " (expected #" + i._requestId + ")") : (a.node && a.error && a.message ? c = a : (c = h._makeHookContext(i, null, {
                        error: a,
                        args: Array.prototype.slice.call(arguments),
                        message: a ? a.message || a.toString() : ""
                    }), "[object Object]" === c.message && (c.message = "")), i.warn("Load children failed (" + c.message + ")", c), void(h._triggerNodeEvent("loadError", c, null) !== !1 && h.nodeSetStatus(b, "error", c.message, c.details)))
                })), a.when(c).done(function(b) {
                    var c;
                    a.isPlainObject(b) && (e(i.isRootNode(), "source may only be an object for root nodes (expecting an array of child objects otherwise)"),
                        e(a.isArray(b.children), "if an object is passed as source, it must contain a 'children' array (all other properties are added to 'tree.data')"), c = b, b = b.children, delete c.children, a.extend(h.data, c)), e(a.isArray(b), "expected array of children"), i._setChildren(b), h._triggerNodeEvent("loadChildren", i)
                })
            },
            nodeLoadKeyPath: function(a, b) {},
            nodeRemoveChild: function(b, c) {
                var d, f = b.node,
                    g = a.extend({}, b, {
                        node: c
                    }),
                    h = f.children;
                return 1 === h.length ? (e(c === h[0], "invalid single child"), this.nodeRemoveChildren(b)) : (this.activeNode && (c === this.activeNode || this.activeNode.isDescendantOf(c)) && this.activeNode.setActive(!1), this.focusNode && (c === this.focusNode || this.focusNode.isDescendantOf(c)) && (this.focusNode = null), this.nodeRemoveMarkup(g), this.nodeRemoveChildren(g), d = a.inArray(c, h), e(d >= 0, "invalid child"), f.triggerModifyChild("remove", c), c.visit(function(a) {
                    a.parent = null
                }, !0), this._callHook("treeRegisterNode", this, !1, c), void h.splice(d, 1))
            },
            nodeRemoveChildMarkup: function(b) {
                var c = b.node;
                c.ul && (c.isRootNode() ? a(c.ul).empty() : (a(c.ul).remove(), c.ul = null), c.visit(function(a) {
                    a.li = a.ul = null
                }))
            },
            nodeRemoveChildren: function(b) {
                var c, d = b.tree,
                    e = b.node,
                    f = e.children;
                f && (this.activeNode && this.activeNode.isDescendantOf(e) && this.activeNode.setActive(!1), this.focusNode && this.focusNode.isDescendantOf(e) && (this.focusNode = null), this.nodeRemoveChildMarkup(b), c = a.extend({}, b), e.triggerModifyChild("remove", null), e.visit(function(a) {
                    a.parent = null, d._callHook("treeRegisterNode", d, !1, a)
                }), e.lazy ? e.children = [] : e.children = null, e.isRootNode() || (e.expanded = !1), this.nodeRenderStatus(b))
            },
            nodeRemoveMarkup: function(b) {
                var c = b.node;
                c.li && (a(c.li).remove(), c.li = null), this.nodeRemoveChildMarkup(b)
            },
            nodeRender: function(b, d, f, g, h) {
                var i, j, k, l, m, n, o, p = b.node,
                    q = b.tree,
                    r = b.options,
                    s = r.aria,
                    t = !1,
                    u = p.parent,
                    v = !u,
                    w = p.children,
                    x = null;
                if (q._enableUpdate !== !1 && (v || u.ul)) {
                    if (e(v || u.ul, "parent UL must exist"), v || (p.li && (d || p.li.parentNode !== p.parent.ul) && (p.li.parentNode === p.parent.ul ? x = p.li.nextSibling : this.debug("Unlinking " + p + " (must be child of " + p.parent + ")"), this.nodeRemoveMarkup(b)), p.li ? this.nodeRenderStatus(b) : (t = !0, p.li = c.createElement("li"), p.li.ftnode = p, p.key && r.generateIds && (p.li.id = r.idPrefix + p.key), p.span = c.createElement("span"), p.span.className = "fancytree-node", s && !p.tr && a(p.span).attr("role", "treeitem"), p.li.appendChild(p.span), this.nodeRenderTitle(b), r.createNode && r.createNode.call(q, {
                            type: "createNode"
                        }, b)), r.renderNode && r.renderNode.call(q, {
                            type: "renderNode"
                        }, b)), w) {
                        if (v || p.expanded || f === !0) {
                            for (p.ul || (p.ul = c.createElement("ul"), (g !== !0 || h) && p.expanded || (p.ul.style.display = "none"), s && a(p.ul).attr("role", "group"), p.li ? p.li.appendChild(p.ul) : p.tree.$div.append(p.ul)), l = 0, m = w.length; l < m; l++) o = a.extend({}, b, {
                                node: w[l]
                            }), this.nodeRender(o, d, f, !1, !0);
                            for (i = p.ul.firstChild; i;) k = i.ftnode, k && k.parent !== p ? (p.debug("_fixParent: remove missing " + k, i), n = i.nextSibling, i.parentNode.removeChild(i), i = n) : i = i.nextSibling;
                            for (i = p.ul.firstChild, l = 0, m = w.length - 1; l < m; l++) j = w[l], k = i.ftnode, j !== k ? p.ul.insertBefore(j.li, k.li) : i = i.nextSibling
                        }
                    } else p.ul && (this.warn("remove child markup for " + p), this.nodeRemoveChildMarkup(b));
                    v || t && u.ul.insertBefore(p.li, x)
                }
            },
            nodeRenderTitle: function(b, c) {
                var e, f, g, h, i, j, k = b.node,
                    l = b.tree,
                    m = b.options,
                    n = m.aria,
                    q = k.getLevel(),
                    r = [];
                c !== d && (k.title = c), k.span && l._enableUpdate !== !1 && (h = n && k.hasChildren() !== !1 ? " role='button'" : "", q < m.minExpandLevel ? (k.lazy || (k.expanded = !0), q > 1 && r.push("<span " + h + " class='fancytree-expander fancytree-expander-fixed'></span>")) : r.push("<span " + h + " class='fancytree-expander'></span>"), m.checkbox && k.hideCheckbox !== !0 && !k.isStatusNode() && (h = n ? " role='checkbox'" : "", r.push("<span " + h + " class='fancytree-checkbox'></span>")), k.data.iconClass !== d && (k.icon ? a.error("'iconClass' node option is deprecated since v2.14.0: use 'icon' only instead") : (k.warn("'iconClass' node option is deprecated since v2.14.0: use 'icon' instead"), k.icon = k.data.iconClass)), f = w.evalOption("icon", k, k, m, !0), "boolean" != typeof f && (f = "" + f), f !== !1 && (h = n ? " role='presentation'" : "", "string" == typeof f ? x.test(f) ? (f = "/" === f.charAt(0) ? f : (m.imagePath || "") + f, r.push("<img src='" + f + "' class='fancytree-icon' alt='' />")) : r.push("<span " + h + " class='fancytree-custom-icon " + f + "'></span>") : r.push("<span " + h + " class='fancytree-icon'></span>")), g = "", m.renderTitle && (g = m.renderTitle.call(l, {
                    type: "renderTitle"
                }, b) || ""), g || (k.tooltip ? j = k.tooltip : m.tooltip && (j = m.tooltip === !0 ? k.title : m.tooltip.call(l, k)), j = j ? " title='" + p(j) + "'" : "", e = "", h = "", i = m.titlesTabbable ? " tabindex='0'" : "", g = "<span " + h + " class='fancytree-title'" + e + j + i + ">" + (m.escapeTitles ? o(k.title) : k.title) + "</span>"), r.push(g), k.span.innerHTML = r.join(""), this.nodeRenderStatus(b), m.enhanceTitle && (b.$title = a(">span.fancytree-title", k.span), g = m.enhanceTitle.call(l, {
                    type: "enhanceTitle"
                }, b) || ""))
            },
            nodeRenderStatus: function(b) {
                var c, d = b.node,
                    e = b.tree,
                    f = b.options,
                    g = d.hasChildren(),
                    h = d.isLastSibling(),
                    i = f.aria,
                    j = f._classNames,
                    k = [],
                    l = d[e.statusClassPropName];
                l && e._enableUpdate !== !1 && (i && (c = a(d.tr ? d.tr : d.span)), k.push(j.node), e.activeNode === d && k.push(j.active), e.focusNode === d && k.push(j.focused), d.expanded ? (k.push(j.expanded), i && c.attr("aria-expanded", !0)) : i && (g ? c.attr("aria-expanded", !1) : c.removeAttr("aria-expanded")), d.folder && k.push(j.folder), g !== !1 && k.push(j.hasChildren), h && k.push(j.lastsib), d.lazy && null == d.children && k.push(j.lazy), d.partload && k.push(j.partload), d.partsel && k.push(j.partsel), d.unselectable && k.push(j.unselectable), d._isLoading && k.push(j.loading), d._error && k.push(j.error), d.statusNodeType && k.push(j.statusNodePrefix + d.statusNodeType), d.selected ? (k.push(j.selected), i && c.attr("aria-selected", !0)) : i && c.attr("aria-selected", !1), d.extraClasses && k.push(d.extraClasses), g === !1 ? k.push(j.combinedExpanderPrefix + "n" + (h ? "l" : "")) : k.push(j.combinedExpanderPrefix + (d.expanded ? "e" : "c") + (d.lazy && null == d.children ? "d" : "") + (h ? "l" : "")), k.push(j.combinedIconPrefix + (d.expanded ? "e" : "c") + (d.folder ? "f" : "")), l.className = k.join(" "), d.li && a(d.li).toggleClass(j.lastsib, h))
            },
            nodeSetActive: function(b, c, d) {
                d = d || {};
                var f, g = b.node,
                    h = b.tree,
                    i = b.options,
                    j = d.noEvents === !0,
                    m = d.noFocus === !0,
                    n = g === h.activeNode;
                return c = c !== !1, n === c ? k(g) : c && !j && this._triggerNodeEvent("beforeActivate", g, b.originalEvent) === !1 ? l(g, ["rejected"]) : (c ? (h.activeNode && (e(h.activeNode !== g, "node was active (inconsistency)"), f = a.extend({}, b, {
                    node: h.activeNode
                }), h.nodeSetActive(f, !1), e(null === h.activeNode, "deactivate was out of sync?")), i.activeVisible && g.makeVisible({
                    scrollIntoView: m && null == h.focusNode
                }), h.activeNode = g, h.nodeRenderStatus(b), m || h.nodeSetFocus(b), j || h._triggerNodeEvent("activate", g, b.originalEvent)) : (e(h.activeNode === g, "node was not active (inconsistency)"), h.activeNode = null, this.nodeRenderStatus(b), j || b.tree._triggerNodeEvent("deactivate", g, b.originalEvent)), k(g))
            },
            nodeSetExpanded: function(b, c, e) {
                e = e || {};
                var f, g, h, i, j, m, n = b.node,
                    o = b.tree,
                    p = b.options,
                    q = e.noAnimation === !0,
                    r = e.noEvents === !0;
                if (c = c !== !1, n.expanded && c || !n.expanded && !c) return k(n);
                if (c && !n.lazy && !n.hasChildren()) return k(n);
                if (!c && n.getLevel() < p.minExpandLevel) return l(n, ["locked"]);
                if (!r && this._triggerNodeEvent("beforeExpand", n, b.originalEvent) === !1) return l(n, ["rejected"]);
                if (q || n.isVisible() || (q = e.noAnimation = !0), g = new a.Deferred, c && !n.expanded && p.autoCollapse) {
                    j = n.getParentList(!1, !0), m = p.autoCollapse;
                    try {
                        for (p.autoCollapse = !1, h = 0, i = j.length; h < i; h++) this._callHook("nodeCollapseSiblings", j[h], e)
                    } finally {
                        p.autoCollapse = m
                    }
                }
                return g.done(function() {
                    var a = n.getLastChild();
                    c && p.autoScroll && !q && a ? a.scrollIntoView(!0, {
                        topNode: n
                    }).always(function() {
                        r || b.tree._triggerNodeEvent(c ? "expand" : "collapse", b)
                    }) : r || b.tree._triggerNodeEvent(c ? "expand" : "collapse", b)
                }), f = function(d) {
                    var e, f, g = p._classNames,
                        h = p.toggleEffect;
                    if (n.expanded = c, o._callHook("nodeRender", b, !1, !1, !0), n.ul)
                        if (e = "none" !== n.ul.style.display, f = !!n.expanded, e === f) n.warn("nodeSetExpanded: UL.style.display already set");
                        else {
                            if (h && !q) return a(n.li).addClass(g.animating), void a(n.ul).addClass(g.animating).toggle(h.effect, h.options, h.duration, function() {
                                a(this).removeClass(g.animating), a(n.li).removeClass(g.animating), d()
                            });
                            n.ul.style.display = n.expanded || !parent ? "" : "none"
                        } d()
                }, c && n.lazy && n.hasChildren() === d ? n.load().done(function() {
                    g.notifyWith && g.notifyWith(n, ["loaded"]), f(function() {
                        g.resolveWith(n)
                    })
                }).fail(function(a) {
                    f(function() {
                        g.rejectWith(n, ["load failed (" + a + ")"])
                    })
                }) : f(function() {
                    g.resolveWith(n)
                }), g.promise()
            },
            nodeSetFocus: function(b, d) {
                var e, f = b.tree,
                    g = b.node,
                    h = f.options,
                    i = !!b.originalEvent && a(b.originalEvent.target).is(":input");
                if (d = d !== !1, f.focusNode) {
                    if (f.focusNode === g && d) return;
                    e = a.extend({}, b, {
                        node: f.focusNode
                    }), f.focusNode = null, this._triggerNodeEvent("blur", e), this._callHook("nodeRenderStatus", e)
                }
                d && (this.hasFocus() || (g.debug("nodeSetFocus: forcing container focus"), this._callHook("treeSetFocus", b, !0, {
                    calledByNode: !0
                })), g.makeVisible({
                    scrollIntoView: !1
                }), f.focusNode = g, h.titlesTabbable ? i || a(g.span).find(".fancytree-title").focus() : 0 === a(c.activeElement).closest(".fancytree-container").length && a(f.$container).focus(), h.aria && a(f.$container).attr("aria-activedescendant", a(g.tr || g.span).uniqueId().attr("id")), this._triggerNodeEvent("focus", b), h.autoScroll && g.scrollIntoView(), this._callHook("nodeRenderStatus", b))
            },
            nodeSetSelected: function(a, b) {
                var c = a.node,
                    d = a.tree,
                    e = a.options;
                if (b = b !== !1, !c.unselectable) {
                    if (c.selected && b || !c.selected && !b) return !!c.selected;
                    if (this._triggerNodeEvent("beforeSelect", c, a.originalEvent) === !1) return !!c.selected;
                    b && 1 === e.selectMode ? d.lastSelectedNode && d.lastSelectedNode.setSelected(!1) : 3 === e.selectMode && (c.selected = b, c.fixSelection3AfterClick()), c.selected = b, this.nodeRenderStatus(a), d.lastSelectedNode = b ? c : null, d._triggerNodeEvent("select", a)
                }
            },
            nodeSetStatus: function(b, c, d, e) {
                function f() {
                    var a = h.children ? h.children[0] : null;
                    if (a && a.isStatusNode()) {
                        try {
                            h.ul && (h.ul.removeChild(a.li), a.li = null)
                        } catch (b) {}
                        1 === h.children.length ? h.children = [] : h.children.shift()
                    }
                }

                function g(b, c) {
                    var d = h.children ? h.children[0] : null;
                    return d && d.isStatusNode() ? (a.extend(d, b), d.statusNodeType = c, i._callHook("nodeRenderTitle", d)) : (h._setChildren([b]), h.children[0].statusNodeType = c, i.render()), h.children[0]
                }
                var h = b.node,
                    i = b.tree;
                switch (c) {
                    case "ok":
                        f(), h._isLoading = !1, h._error = null, h.renderStatus();
                        break;
                    case "loading":
                        h.parent || g({
                            title: i.options.strings.loading + (d ? " (" + d + ")" : ""),
                            checkbox: !1,
                            tooltip: e
                        }, c), h._isLoading = !0, h._error = null, h.renderStatus();
                        break;
                    case "error":
                        g({
                            title: i.options.strings.loadError + (d ? " (" + d + ")" : ""),
                            checkbox: !1,
                            tooltip: e
                        }, c), h._isLoading = !1, h._error = {
                            message: d,
                            details: e
                        }, h.renderStatus();
                        break;
                    case "nodata":
                        g({
                            title: i.options.strings.noData,
                            checkbox: !1,
                            tooltip: e
                        }, c), h._isLoading = !1, h._error = null, h.renderStatus();
                        break;
                    default:
                        a.error("invalid node status " + c)
                }
            },
            nodeToggleExpanded: function(a) {
                return this.nodeSetExpanded(a, !a.node.expanded)
            },
            nodeToggleSelected: function(a) {
                return this.nodeSetSelected(a, !a.node.selected)
            },
            treeClear: function(a) {
                var b = a.tree;
                b.activeNode = null, b.focusNode = null, b.$div.find(">ul.fancytree-container").empty(), b.rootNode.children = null
            },
            treeCreate: function(a) {},
            treeDestroy: function(a) {
                this.$div.find(">ul.fancytree-container").remove(), this.$source && this.$source.removeClass("ui-helper-hidden")
            },
            treeInit: function(a) {
                var b = a.tree,
                    c = b.options;
                b.$container.attr("tabindex", c.tabindex), c.rtl ? b.$container.attr("DIR", "RTL").addClass("fancytree-rtl") : b.$container.removeAttr("DIR").removeClass("fancytree-rtl"), c.aria && (b.$container.attr("role", "tree"), 1 !== c.selectMode && b.$container.attr("aria-multiselectable", !0)), this.treeLoad(a)
            },
            treeLoad: function(b, c) {
                var d, f, g, h, i = b.tree,
                    j = b.widget.element,
                    k = a.extend({}, b, {
                        node: this.rootNode
                    });
                if (i.rootNode.children && this.treeClear(b), c = c || this.options.source) "string" == typeof c && a.error("Not implemented");
                else switch (f = j.data("type") || "html") {
                    case "html":
                        g = j.find(">ul:first"), g.addClass("ui-fancytree-source ui-helper-hidden"), c = a.ui.fancytree.parseHtml(g), this.data = a.extend(this.data, n(g));
                        break;
                    case "json":
                        c = a.parseJSON(j.text()), j.contents().filter(function() {
                            return 3 === this.nodeType
                        }).remove(), a.isPlainObject(c) && (e(a.isArray(c.children), "if an object is passed as source, it must contain a 'children' array (all other properties are added to 'tree.data')"), d = c, c = c.children, delete d.children, a.extend(i.data, d));
                        break;
                    default:
                        a.error("Invalid data-type: " + f)
                }
                return h = this.nodeLoadChildren(k, c).done(function() {
                    i.render(), 3 === b.options.selectMode && i.rootNode.fixSelection3FromEndNodes(), i.activeNode && i.options.activeVisible && i.activeNode.makeVisible(), i._triggerTreeEvent("init", null, {
                        status: !0
                    })
                }).fail(function() {
                    i.render(), i._triggerTreeEvent("init", null, {
                        status: !1
                    })
                })
            },
            treeRegisterNode: function(a, b, c) {},
            treeSetFocus: function(b, c, d) {
                function e(a) {
                    !a.activeNode && a.getFirstChild() && a.getFirstChild().setFocus()
                }
                if (c = c !== !1, c !== this.hasFocus() && (this._hasFocus = c, !c && this.focusNode ? this.focusNode.setFocus(!1) : !c || d && d.calledByNode || a(this.$container).focus(), this.$container.toggleClass("fancytree-treefocus", c), this._triggerTreeEvent(c ? "focusTree" : "blurTree"), c)) {
                    var f = this;
                    setTimeout(function() {
                        e(f)
                    }, 0)
                }
            },
            treeSetOption: function(b, c, d) {
                var e = b.tree,
                    f = !0,
                    g = !1;
                switch (c) {
                    case "aria":
                    case "checkbox":
                    case "icon":
                    case "minExpandLevel":
                    case "tabindex":
                        e._callHook("treeCreate", e), g = !0;
                        break;
                    case "escapeTitles":
                    case "tooltip":
                        g = !0;
                        break;
                    case "rtl":
                        d === !1 ? e.$container.removeAttr("DIR").removeClass("fancytree-rtl") : e.$container.attr("DIR", "RTL").addClass("fancytree-rtl"), g = !0;
                        break;
                    case "source":
                        f = !1, e._callHook("treeLoad", e, d), g = !0
                }
                e.debug("set option " + c + "=" + d + " <" + typeof d + ">"), f && (this.widget._super ? this.widget._super.call(this.widget, c, d) : a.Widget.prototype._setOption.call(this.widget, c, d)), g && e.render(!0, !1)
            }
        }), a.widget("ui.fancytree", {
            options: {
                activeVisible: !0,
                ajax: {
                    type: "GET",
                    cache: !1,
                    dataType: "json"
                },
                aria: !1,
                autoActivate: !0,
                autoCollapse: !1,
                autoScroll: !1,
                checkbox: !1,
                clickFolderMode: 4,
                debugLevel: null,
                disabled: !1,
                enableAspx: !0,
                escapeTitles: !1,
                extensions: [],
                toggleEffect: {
                    effect: "blind",
                    options: {
                        direction: "vertical",
                        scale: "box"
                    },
                    duration: 200
                },
                generateIds: !1,
                icon: !0,
                idPrefix: "ft_",
                focusOnSelect: !1,
                keyboard: !0,
                keyPathSeparator: "/",
                minExpandLevel: 1,
                quicksearch: !1,
                rtl: !1,
                scrollOfs: {
                    top: 0,
                    bottom: 0
                },
                scrollParent: null,
                selectMode: 2,
                strings: {
                    loading: "Loading...",
                    loadError: "Load error!",
                    moreData: "More...",
                    noData: "No data."
                },
                tabindex: "0",
                titlesTabbable: !1,
                tooltip: !1,
                _classNames: {
                    node: "fancytree-node",
                    folder: "fancytree-folder",
                    animating: "fancytree-animating",
                    combinedExpanderPrefix: "fancytree-exp-",
                    combinedIconPrefix: "fancytree-ico-",
                    hasChildren: "fancytree-has-children",
                    active: "fancytree-active",
                    selected: "fancytree-selected",
                    expanded: "fancytree-expanded",
                    lazy: "fancytree-lazy",
                    focused: "fancytree-focused",
                    partload: "fancytree-partload",
                    partsel: "fancytree-partsel",
                    unselectable: "fancytree-unselectable",
                    lastsib: "fancytree-lastsib",
                    loading: "fancytree-loading",
                    error: "fancytree-error",
                    statusNodePrefix: "fancytree-statusnode-"
                },
                lazyLoad: null,
                postProcess: null
            },
            _create: function() {
                this.tree = new t(this), this.$source = this.source || "json" === this.element.data("type") ? this.element : this.element.find(">ul:first");
                var b, c, f, g = this.options,
                    h = g.extensions,
                    i = this.tree;
                for (f = 0; f < h.length; f++) c = h[f], b = a.ui.fancytree._extensions[c], b || a.error("Could not apply extension '" + c + "' (it is not registered, did you forget to include it?)"), this.tree.options[c] = a.extend(!0, {}, b.options, this.tree.options[c]), e(this.tree.ext[c] === d, "Extension name must not exist as Fancytree.ext attribute: '" + c + "'"), this.tree.ext[c] = {}, j(this.tree, i, b, c), i = b;
                g.icons !== d && (g.icon !== !0 ? a.error("'icons' tree option is deprecated since v2.14.0: use 'icon' only instead") : (this.tree.warn("'icons' tree option is deprecated since v2.14.0: use 'icon' instead"), g.icon = g.icons)), g.iconClass !== d && (g.icon ? a.error("'iconClass' tree option is deprecated since v2.14.0: use 'icon' only instead") : (this.tree.warn("'iconClass' tree option is deprecated since v2.14.0: use 'icon' instead"), g.icon = g.iconClass)), g.tabbable !== d && (g.tabindex = g.tabbable ? "0" : "-1", this.tree.warn("'tabbable' tree option is deprecated since v2.17.0: use 'tabindex='" + g.tabindex + "' instead")), this.tree._callHook("treeCreate", this.tree)
            },
            _init: function() {
                this.tree._callHook("treeInit", this.tree), this._bind()
            },
            _setOption: function(a, b) {
                return this.tree._callHook("treeSetOption", this.tree, a, b)
            },
            destroy: function() {
                this._unbind(), this.tree._callHook("treeDestroy", this.tree), a.Widget.prototype.destroy.call(this)
            },
            _unbind: function() {
                var b = this.tree._ns;
                this.element.off(b), this.tree.$container.off(b), a(c).off(b)
            },
            _bind: function() {
                var a = this,
                    b = this.options,
                    c = this.tree,
                    d = c._ns;
                this._unbind(), c.$container.on("focusin" + d + " focusout" + d, function(a) {
                    var b = w.getNode(a),
                        d = "focusin" === a.type;
                    b ? c._callHook("nodeSetFocus", c._makeHookContext(b, a), d) : c._callHook("treeSetFocus", c, d)
                }).on("selectstart" + d, "span.fancytree-title", function(a) {
                    a.preventDefault()
                }).on("keydown" + d, function(a) {
                    if (b.disabled || b.keyboard === !1) return !0;
                    var d, e = c.focusNode,
                        f = c._makeHookContext(e || c, a),
                        g = c.phase;
                    try {
                        return c.phase = "userEvent", d = e ? c._triggerNodeEvent("keydown", e, a) : c._triggerTreeEvent("keydown", a), "preventNav" === d ? d = !0 : d !== !1 && (d = c._callHook("nodeKeydown", f)), d
                    } finally {
                        c.phase = g
                    }
                }).on("mousedown" + d + " dblclick" + d, function(c) {
                    if (b.disabled) return !0;
                    var d, e = w.getEventTarget(c),
                        f = e.node,
                        g = a.tree,
                        h = g.phase;
                    if (!f) return !0;
                    d = g._makeHookContext(f, c);
                    try {
                        switch (g.phase = "userEvent", c.type) {
                            case "mousedown":
                                return d.targetType = e.type, f.isPagingNode() ? g._triggerNodeEvent("clickPaging", d, c) === !0 : g._triggerNodeEvent("click", d, c) !== !1 && g._callHook("nodeClick", d);
                            case "dblclick":
                                return d.targetType = e.type, g._triggerNodeEvent("dblclick", d, c) !== !1 && g._callHook("nodeDblclick", d)
                        }
                    } finally {
                        g.phase = h
                    }
                })
            },
            getActiveNode: function() {
                return this.tree.activeNode
            },
            getNodeByKey: function(a) {
                return this.tree.getNodeByKey(a)
            },
            getRootNode: function() {
                return this.tree.rootNode
            },
            getTree: function() {
                return this.tree
            }
        }), w = a.ui.fancytree, a.extend(a.ui.fancytree, {
            version: "2.22.4",
            buildType: "production",
            debugLevel: 1,
            _nextId: 1,
            _nextNodeKey: 1,
            _extensions: {},
            _FancytreeClass: t,
            _FancytreeNodeClass: s,
            jquerySupports: {
                positionMyOfs: h(a.ui.version, 1, 9)
            },
            assert: function(a, b) {
                return e(a, b)
            },
            debounce: function(a, b, c, d) {
                var e;
                return 3 === arguments.length && "boolean" != typeof c && (d = c, c = !1),
                    function() {
                        var f = arguments;
                        d = d || this, c && !e && b.apply(d, f), clearTimeout(e), e = setTimeout(function() {
                            c || b.apply(d, f), e = null
                        }, a)
                    }
            },
            debug: function(b) {
                a.ui.fancytree.debugLevel >= 2 && f("log", arguments)
            },
            error: function(a) {
                f("error", arguments)
            },
            escapeHtml: o,
            fixPositionOptions: function(b) {
                if ((b.offset || ("" + b.my + b.at).indexOf("%") >= 0) && a.error("expected new position syntax (but '%' is not supported)"), !a.ui.fancytree.jquerySupports.positionMyOfs) {
                    var c = /(\w+)([+-]?\d+)?\s+(\w+)([+-]?\d+)?/.exec(b.my),
                        d = /(\w+)([+-]?\d+)?\s+(\w+)([+-]?\d+)?/.exec(b.at),
                        e = (c[2] ? +c[2] : 0) + (d[2] ? +d[2] : 0),
                        f = (c[4] ? +c[4] : 0) + (d[4] ? +d[4] : 0);
                    b = a.extend({}, b, {
                        my: c[1] + " " + c[3],
                        at: d[1] + " " + d[3]
                    }), (e || f) && (b.offset = "" + e + " " + f)
                }
                return b
            },
            getEventTargetType: function(a) {
                return this.getEventTarget(a).type
            },
            getEventTarget: function(b) {
                var c = b && b.target ? b.target.className : "",
                    e = {
                        node: this.getNode(b.target),
                        type: d
                    };
                return /\bfancytree-title\b/.test(c) ? e.type = "title" : /\bfancytree-expander\b/.test(c) ? e.type = e.node.hasChildren() === !1 ? "prefix" : "expander" : /\bfancytree-checkbox\b/.test(c) || /\bfancytree-radio\b/.test(c) ? e.type = "checkbox" : /\bfancytree-icon\b/.test(c) ? e.type = "icon" : /\bfancytree-node\b/.test(c) ? e.type = "title" : b && b.target && a(b.target).closest(".fancytree-title").length && (e.type = "title"), e
            },
            getNode: function(a) {
                if (a instanceof s) return a;
                for (a instanceof jQuery ? a = a[0] : a.originalEvent !== d && (a = a.target); a;) {
                    if (a.ftnode) return a.ftnode;
                    a = a.parentNode
                }
                return null
            },
            getTree: function(b) {
                var c;
                return b instanceof t ? b : (b === d && (b = 0), "number" == typeof b ? b = a(".fancytree-container").eq(b) : "string" == typeof b ? b = a(b).eq(0) : b.selector !== d ? b = b.eq(0) : b.originalEvent !== d && (b = a(b.target)), b = b.closest(":ui-fancytree"), c = b.data("ui-fancytree") || b.data("fancytree"), c ? c.tree : null)
            },
            evalOption: function(b, c, d, e, f) {
                var g, h, i = c.tree,
                    j = e[b],
                    k = d[b];
                return a.isFunction(j) ? (g = {
                    node: c,
                    tree: i,
                    widget: i.widget,
                    options: i.widget.options
                }, h = j.call(i, {
                    type: b
                }, g), null == h && (h = k)) : h = null != k ? k : j, null == h && (h = f), h
            },
            eventToString: function(a) {
                var b = a.which,
                    c = a.type,
                    d = [];
                return a.altKey && d.push("alt"), a.ctrlKey && d.push("ctrl"), a.metaKey && d.push("meta"), a.shiftKey && d.push("shift"), "click" === c || "dblclick" === c ? d.push(E[a.button] + c) : C[b] || d.push(D[b] || String.fromCharCode(b).toLowerCase()), d.join("+")
            },
            info: function(b) {
                a.ui.fancytree.debugLevel >= 1 && f("info", arguments)
            },
            keyEventToString: function(a) {
                return this.warn("keyEventToString() is deprecated: use eventToString()"), this.eventToString(a)
            },
            overrideMethod: function(b, c, d) {
                var e, f = b[c] || a.noop;
                b[c] = function() {
                    try {
                        return e = this._super, this._super = f, d.apply(this, arguments)
                    } finally {
                        this._super = e
                    }
                }
            },
            parseHtml: function(b) {
                var c, e, f, g, h, i, j, k, l = b.find(">li"),
                    m = [];
                return l.each(function() {
                    var l, o, p = a(this),
                        q = p.find(">span:first", this),
                        r = q.length ? null : p.find(">a:first"),
                        s = {
                            tooltip: null,
                            data: {}
                        };
                    for (q.length ? s.title = q.html() : r && r.length ? (s.title = r.html(), s.data.href = r.attr("href"), s.data.target = r.attr("target"), s.tooltip = r.attr("title")) : (s.title = p.html(), h = s.title.search(/<ul/i), h >= 0 && (s.title = s.title.substring(0, h))), s.title = a.trim(s.title), g = 0, i = F.length; g < i; g++) s[F[g]] = d;
                    for (c = this.className.split(" "), f = [], g = 0, i = c.length; g < i; g++) e = c[g], G[e] ? s[e] = !0 : f.push(e);
                    if (s.extraClasses = f.join(" "), j = p.attr("title"), j && (s.tooltip = j), j = p.attr("id"), j && (s.key = j), l = n(p), l && !a.isEmptyObject(l)) {
                        for (o in J) l.hasOwnProperty(o) && (l[J[o]] = l[o], delete l[o]);
                        for (g = 0, i = H.length; g < i; g++) j = H[g], k = l[j], null != k && (delete l[j], s[j] = k);
                        a.extend(s.data, l)
                    }
                    b = p.find(">ul:first"), b.length ? s.children = a.ui.fancytree.parseHtml(b) : s.children = s.lazy ? d : null, m.push(s)
                }), m
            },
            registerExtension: function(b) {
                e(null != b.name, "extensions must have a `name` property."), e(null != b.version, "extensions must have a `version` property."), a.ui.fancytree._extensions[b.name] = b
            },
            unescapeHtml: function(a) {
                var b = c.createElement("div");
                return b.innerHTML = a, 0 === b.childNodes.length ? "" : b.childNodes[0].nodeValue
            },
            warn: function(a) {
                f("warn", arguments)
            }
        })
    }(jQuery, window, document);

    /*! Extension 'jquery.fancytree.childcounter.min.js' */
    ! function(a, b) {
        "use strict";
        a.ui.fancytree._FancytreeClass.prototype.countSelected = function(a) {
            var b = this;
            b.options;
            return b.getSelectedNodes(a).length
        }, a.ui.fancytree._FancytreeNodeClass.prototype.updateCounters = function() {
            var b = this,
                c = a("span.fancytree-childcounter", b.span),
                d = b.tree.options.childcounter,
                e = b.countChildren(d.deep);
            b.data.childCounter = e, !e && d.hideZeros || b.isExpanded() && d.hideExpanded ? c.remove() : (c.length || (c = a("<span class='fancytree-childcounter'/>").appendTo(a("span.fancytree-icon", b.span))), c.text(e)), !d.deep || b.isTopLevel() || b.isRoot() || b.parent.updateCounters()
        }, a.ui.fancytree.prototype.widgetMethod1 = function(a) {
            this.tree;
            return a
        }, a.ui.fancytree.registerExtension({
            name: "childcounter",
            version: "2.22.4",
            options: {
                deep: !0,
                hideZeros: !0,
                hideExpanded: !1
            },
            foo: 42,
            _appendCounter: function(a) {},
            treeInit: function(a) {
                a.options, a.options.childcounter;
                this._superApply(arguments), this.$container.addClass("fancytree-ext-childcounter")
            },
            treeDestroy: function(a) {
                this._superApply(arguments)
            },
            nodeRenderTitle: function(b, c) {
                var d = b.node,
                    e = b.options.childcounter,
                    f = null == d.data.childCounter ? d.countChildren(e.deep) : +d.data.childCounter;
                this._super(b, c), !f && e.hideZeros || d.isExpanded() && e.hideExpanded || a("span.fancytree-icon", d.span).append(a("<span class='fancytree-childcounter'/>").text(f))
            },
            nodeSetExpanded: function(a, b, c) {
                var d = a.tree;
                a.node;
                return this._superApply(arguments).always(function() {
                    d.nodeRenderTitle(a)
                })
            }
        })
    }(jQuery);

    /*! Extension 'jquery.fancytree.clones.min.js' */
    ! function(a, b, c, d) {
        "use strict";

        function e(b, c) {
            b || (c = c ? ": " + c : "", a.error("Assertion failed" + c))
        }

        function f(a, b) {
            var c;
            for (c = a.length - 1; c >= 0; c--)
                if (a[c] === b) return a.splice(c, 1), !0;
            return !1
        }

        function g(a, b, c) {
            for (var d, e, f = 3 & a.length, g = a.length - f, h = c, i = 3432918353, j = 461845907, k = 0; k < g;) e = 255 & a.charCodeAt(k) | (255 & a.charCodeAt(++k)) << 8 | (255 & a.charCodeAt(++k)) << 16 | (255 & a.charCodeAt(++k)) << 24, ++k, e = (65535 & e) * i + (((e >>> 16) * i & 65535) << 16) & 4294967295, e = e << 15 | e >>> 17, e = (65535 & e) * j + (((e >>> 16) * j & 65535) << 16) & 4294967295, h ^= e, h = h << 13 | h >>> 19, d = 5 * (65535 & h) + ((5 * (h >>> 16) & 65535) << 16) & 4294967295, h = (65535 & d) + 27492 + (((d >>> 16) + 58964 & 65535) << 16);
            switch (e = 0, f) {
                case 3:
                    e ^= (255 & a.charCodeAt(k + 2)) << 16;
                case 2:
                    e ^= (255 & a.charCodeAt(k + 1)) << 8;
                case 1:
                    e ^= 255 & a.charCodeAt(k), e = (65535 & e) * i + (((e >>> 16) * i & 65535) << 16) & 4294967295, e = e << 15 | e >>> 17, e = (65535 & e) * j + (((e >>> 16) * j & 65535) << 16) & 4294967295, h ^= e
            }
            return h ^= a.length, h ^= h >>> 16, h = 2246822507 * (65535 & h) + ((2246822507 * (h >>> 16) & 65535) << 16) & 4294967295, h ^= h >>> 13, h = 3266489909 * (65535 & h) + ((3266489909 * (h >>> 16) & 65535) << 16) & 4294967295, h ^= h >>> 16, b ? ("0000000" + (h >>> 0).toString(16)).substr(-8) : h >>> 0
        }

        function h(b) {
            var c, d = a.map(b.getParentList(!1, !0), function(a) {
                return a.refKey || a.key
            });
            return d = d.join("/"), c = "id_" + g(d, !0)
        }
        a.ui.fancytree._FancytreeNodeClass.prototype.getCloneList = function(b) {
            var c, d = this.tree,
                e = d.refMap[this.refKey] || null,
                f = d.keyMap;
            return e && (c = this.key, b ? e = a.map(e, function(a) {
                return f[a]
            }) : (e = a.map(e, function(a) {
                return a === c ? null : f[a]
            }), e.length < 1 && (e = null))), e
        }, a.ui.fancytree._FancytreeNodeClass.prototype.isClone = function() {
            var a = this.refKey || null,
                b = a && this.tree.refMap[a] || null;
            return !!(b && b.length > 1)
        }, a.ui.fancytree._FancytreeNodeClass.prototype.reRegister = function(b, c) {
            b = null == b ? null : "" + b, c = null == c ? null : "" + c;
            var d = this.tree,
                e = this.key,
                f = this.refKey,
                g = d.keyMap,
                h = d.refMap,
                i = h[f] || null,
                j = !1;
            return null != b && b !== this.key && (g[b] && a.error("[ext-clones] reRegister(" + b + "): already exists: " + this), delete g[e], g[b] = this, i && (h[f] = a.map(i, function(a) {
                return a === e ? b : a
            })), this.key = b, j = !0), null != c && c !== this.refKey && (i && (1 === i.length ? delete h[f] : h[f] = a.map(i, function(a) {
                return a === e ? null : a
            })), h[c] ? h[c].append(b) : h[c] = [this.key], this.refKey = c, j = !0), j
        }, a.ui.fancytree._FancytreeNodeClass.prototype.setRefKey = function(a) {
            return this.reRegister(null, a)
        }, a.ui.fancytree._FancytreeClass.prototype.getNodesByRef = function(b, c) {
            var d = this.keyMap,
                e = this.refMap[b] || null;
            return e && (e = c ? a.map(e, function(a) {
                var b = d[a];
                return b.isDescendantOf(c) ? b : null
            }) : a.map(e, function(a) {
                return d[a]
            }), e.length < 1 && (e = null)), e
        }, a.ui.fancytree._FancytreeClass.prototype.changeRefKey = function(a, b) {
            var c, d, e = this.keyMap,
                f = this.refMap[a] || null;
            if (f) {
                for (c = 0; c < f.length; c++) d = e[f[c]], d.refKey = b;
                delete this.refMap[a], this.refMap[b] = f
            }
        }, a.ui.fancytree.registerExtension({
            name: "clones",
            version: "2.22.4",
            options: {
                highlightActiveClones: !0,
                highlightClones: !1
            },
            treeCreate: function(a) {
                this._superApply(arguments), a.tree.refMap = {}, a.tree.keyMap = {}
            },
            treeInit: function(a) {
                this.$container.addClass("fancytree-ext-clones"), e(null == a.options.defaultKey), a.options.defaultKey = function(a) {
                    return h(a)
                }, this._superApply(arguments)
            },
            treeClear: function(a) {
                return a.tree.refMap = {}, a.tree.keyMap = {}, this._superApply(arguments)
            },
            treeRegisterNode: function(b, c, d) {
                var g, h, i = b.tree,
                    j = i.keyMap,
                    k = i.refMap,
                    l = d.key,
                    m = d && null != d.refKey ? "" + d.refKey : null;
                return d.isStatusNode() ? this._super(b, c, d) : (c ? (null != j[d.key] && a.error("clones.treeRegisterNode: node.key already exists: " + d), j[l] = d, m && (g = k[m], g ? (g.push(l), 2 === g.length && b.options.clones.highlightClones && j[g[0]].renderStatus()) : k[m] = [l])) : (null == j[l] && a.error("clones.treeRegisterNode: node.key not registered: " + d.key), delete j[l], m && (g = k[m], g && (h = g.length, h <= 1 ? (e(1 === h), e(g[0] === l), delete k[m]) : (f(g, l), 2 === h && b.options.clones.highlightClones && j[g[0]].renderStatus())))), this._super(b, c, d))
            },
            nodeRenderStatus: function(b) {
                var c, d, e = b.node;
                return d = this._super(b), b.options.clones.highlightClones && (c = a(e[b.tree.statusClassPropName]), c.length && e.isClone() && c.addClass("fancytree-clone")), d
            },
            nodeSetActive: function(b, c, d) {
                var e, f = b.tree.statusClassPropName,
                    g = b.node;
                return e = this._superApply(arguments), b.options.clones.highlightActiveClones && g.isClone() && a.each(g.getCloneList(!0), function(b, d) {
                    a(d[f]).toggleClass("fancytree-active-clone", c !== !1)
                }), e
            }
        })
    }(jQuery, window, document);

    /*! Extension 'jquery.fancytree.dnd.min.js' */
    ! function(a, b, c, d) {
        "use strict";

        function e(a) {
            return 0 === a ? "" : a > 0 ? "+" + a : "" + a
        }

        function f() {
            h || (a.ui.plugin.add("draggable", "connectToFancytree", {
                start: function(b, c) {
                    var d = a(this).data("ui-draggable") || a(this).data("draggable"),
                        e = c.helper.data("ftSourceNode") || null;
                    if (e) return d.offset.click.top = -2, d.offset.click.left = 16, e.tree.ext.dnd._onDragEvent("start", e, null, b, c, d)
                },
                drag: function(b, c) {
                    var d, e, f, g = a(this).data("ui-draggable") || a(this).data("draggable"),
                        h = c.helper.data("ftSourceNode") || null,
                        i = c.helper.data("ftTargetNode") || null,
                        j = a.ui.fancytree.getNode(b.target),
                        k = h && h.tree.options.dnd;
                    return b.target && !j && (e = a(b.target).closest("div.fancytree-drag-helper,#fancytree-drop-marker").length > 0) ? (f = h || i || a.ui.fancytree, void f.debug("Drag event over helper: ignored.")) : (c.helper.data("ftTargetNode", j), k && k.updateHelper && (d = h.tree._makeHookContext(h, b, {
                        otherNode: j,
                        ui: c,
                        draggable: g,
                        dropMarker: a("#fancytree-drop-marker")
                    }), k.updateHelper.call(h.tree, h, d)), i && i !== j && i.tree.ext.dnd._onDragEvent("leave", i, h, b, c, g), void(j && j.tree.options.dnd.dragDrop && (j === i ? j.tree.ext.dnd._onDragEvent("over", j, h, b, c, g) : (j.tree.ext.dnd._onDragEvent("enter", j, h, b, c, g), j.tree.ext.dnd._onDragEvent("over", j, h, b, c, g)))))
                },
                stop: function(b, c) {
                    var d, e = a(this).data("ui-draggable") || a(this).data("draggable"),
                        f = c.helper.data("ftSourceNode") || null,
                        g = c.helper.data("ftTargetNode") || null,
                        h = "mouseup" === b.type && 1 === b.which;
                    h || (d = f || g || a.ui.fancytree, d.debug("Drag was cancelled")), g && (h && g.tree.ext.dnd._onDragEvent("drop", g, f, b, c, e), g.tree.ext.dnd._onDragEvent("leave", g, f, b, c, e)), f && f.tree.ext.dnd._onDragEvent("stop", f, null, b, c, e)
                }
            }), h = !0)
        }

        function g(b) {
            var c = b.options.dnd || null,
                d = b.options.glyph || null;
            c && f(), c && c.dragStart && b.widget.element.draggable(a.extend({
                addClasses: !1,
                appendTo: b.$container,
                containment: !1,
                delay: 0,
                distance: 4,
                revert: !1,
                scroll: !0,
                scrollSpeed: 7,
                scrollSensitivity: 10,
                connectToFancytree: !0,
                helper: function(b) {
                    var c, e, f, g = a.ui.fancytree.getNode(b.target);
                    return g ? (f = g.tree.options.dnd, e = a(g.span), c = a("<div class='fancytree-drag-helper'><span class='fancytree-drag-helper-img' /></div>").css({
                        zIndex: 3,
                        position: "relative"
                    }).append(e.find("span.fancytree-title").clone()), c.data("ftSourceNode", g), d && c.find(".fancytree-drag-helper-img").addClass(d.map.dragHelper), f.initHelper && f.initHelper.call(g.tree, g, {
                        node: g,
                        tree: g.tree,
                        originalEvent: b,
                        ui: {
                            helper: c
                        }
                    }), c) : "<div>ERROR?: helper requested but sourceNode not found</div>"
                },
                start: function(a, b) {
                    var c = b.helper.data("ftSourceNode");
                    return !!c
                }
            }, b.options.dnd.draggable)), c && c.dragDrop && b.widget.element.droppable(a.extend({
                addClasses: !1,
                tolerance: "intersect",
                greedy: !1
            }, b.options.dnd.droppable))
        }
        var h = !1,
            i = "fancytree-drop-accept",
            j = "fancytree-drop-after",
            k = "fancytree-drop-before",
            l = "fancytree-drop-over",
            m = "fancytree-drop-reject",
            n = "fancytree-drop-target";
        a.ui.fancytree.registerExtension({
            name: "dnd",
            version: "2.22.4",
            options: {
                autoExpandMS: 1e3,
                draggable: null,
                droppable: null,
                focusOnClick: !1,
                preventVoidMoves: !0,
                preventRecursiveMoves: !0,
                smartRevert: !0,
                dropMarkerOffsetX: -24,
                dropMarkerInsertOffsetX: -16,
                dragStart: null,
                dragStop: null,
                initHelper: null,
                updateHelper: null,
                dragEnter: null,
                dragOver: null,
                dragExpand: null,
                dragDrop: null,
                dragLeave: null
            },
            treeInit: function(b) {
                var c = b.tree;
                this._superApply(arguments), c.options.dnd.dragStart && c.$container.on("mousedown", function(c) {
                    if (b.options.dnd.focusOnClick) {
                        var d = a.ui.fancytree.getNode(c);
                        d && d.debug("Re-enable focus that was prevented by jQuery UI draggable."), setTimeout(function() {
                            a(c.target).closest(":tabbable").focus()
                        }, 10)
                    }
                }), g(c)
            },
            _setDndStatus: function(b, c, d, f, g) {
                var h, o = "center",
                    p = this._local,
                    q = this.options.dnd,
                    r = this.options.glyph,
                    s = b ? a(b.span) : null,
                    t = a(c.span),
                    u = t.find("span.fancytree-title");
                if (p.$dropMarker || (p.$dropMarker = a("<div id='fancytree-drop-marker'></div>").hide().css({
                        "z-index": 1e3
                    }).prependTo(a(this.$div).parent()), r && p.$dropMarker.addClass(r.map.dropMarker)), "after" === f || "before" === f || "over" === f) {
                    switch (h = q.dropMarkerOffsetX || 0, f) {
                        case "before":
                            o = "top", h += q.dropMarkerInsertOffsetX || 0;
                            break;
                        case "after":
                            o = "bottom", h += q.dropMarkerInsertOffsetX || 0
                    }
                    p.$dropMarker.toggleClass(j, "after" === f).toggleClass(l, "over" === f).toggleClass(k, "before" === f).show().position(a.ui.fancytree.fixPositionOptions({
                        my: "left" + e(h) + " center",
                        at: "left " + o,
                        of: u
                    }))
                } else p.$dropMarker.hide();
                s && s.toggleClass(i, g === !0).toggleClass(m, g === !1), t.toggleClass(n, "after" === f || "before" === f || "over" === f).toggleClass(j, "after" === f).toggleClass(k, "before" === f).toggleClass(i, g === !0).toggleClass(m, g === !1), d.toggleClass(i, g === !0).toggleClass(m, g === !1)
            },
            _onDragEvent: function(b, e, f, g, h, i) {
                var j, k, l, m, n, o, p, q, r, s = this.options,
                    t = s.dnd,
                    u = this._makeHookContext(e, g, {
                        otherNode: f,
                        ui: h,
                        draggable: i
                    }),
                    v = null,
                    w = this,
                    x = a(e.span);
                switch (t.smartRevert && (i.options.revert = "invalid"), b) {
                    case "start":
                        e.isStatusNode() ? v = !1 : t.dragStart && (v = t.dragStart(e, u)), v === !1 ? (this.debug("tree.dragStart() cancelled"), h.helper.trigger("mouseup").hide()) : (t.smartRevert && (m = e[u.tree.nodeContainerAttrName].getBoundingClientRect(), l = a(i.options.appendTo)[0].getBoundingClientRect(), i.originalPosition.left = Math.max(0, m.left - l.left), i.originalPosition.top = Math.max(0, m.top - l.top)), x.addClass("fancytree-drag-source"), a(c).on("keydown.fancytree-dnd,mousedown.fancytree-dnd", function(b) {
                            "keydown" === b.type && b.which === a.ui.keyCode.ESCAPE ? w.ext.dnd._cancelDrag() : "mousedown" === b.type && w.ext.dnd._cancelDrag()
                        }));
                        break;
                    case "enter":
                        r = (!t.preventRecursiveMoves || !e.isDescendantOf(f)) && (t.dragEnter ? t.dragEnter(e, u) : null), v = !!r && (a.isArray(r) ? {
                            over: a.inArray("over", r) >= 0,
                            before: a.inArray("before", r) >= 0,
                            after: a.inArray("after", r) >= 0
                        } : {
                            over: r === !0 || "over" === r,
                            before: r === !0 || "before" === r,
                            after: r === !0 || "after" === r
                        }), h.helper.data("enterResponse", v);
                        break;
                    case "over":
                        p = h.helper.data("enterResponse"), q = null, p === !1 || ("string" == typeof p ? q = p : (k = x.offset(), n = {
                            x: g.pageX - k.left,
                            y: g.pageY - k.top
                        }, o = {
                            x: n.x / x.width(),
                            y: n.y / x.height()
                        }, p.after && o.y > .75 ? q = "after" : !p.over && p.after && o.y > .5 ? q = "after" : p.before && o.y <= .25 ? q = "before" : !p.over && p.before && o.y <= .5 ? q = "before" : p.over && (q = "over"), t.preventVoidMoves && (e === f ? (this.debug("    drop over source node prevented"), q = null) : "before" === q && f && e === f.getNextSibling() ? (this.debug("    drop after source node prevented"), q = null) : "after" === q && f && e === f.getPrevSibling() ? (this.debug("    drop before source node prevented"), q = null) : "over" === q && f && f.parent === e && f.isLastSibling() && (this.debug("    drop last child over own parent prevented"), q = null)), h.helper.data("hitMode", q))), "before" === q || "after" === q || !t.autoExpandMS || e.hasChildren() === !1 || e.expanded || t.dragExpand && t.dragExpand(e, u) === !1 || e.scheduleAction("expand", t.autoExpandMS), q && t.dragOver && (u.hitMode = q, v = t.dragOver(e, u)), j = v !== !1 && null !== q, t.smartRevert && (i.options.revert = !j), this._local._setDndStatus(f, e, h.helper, q, j);
                        break;
                    case "drop":
                        q = h.helper.data("hitMode"), q && t.dragDrop && (u.hitMode = q, t.dragDrop(e, u));
                        break;
                    case "leave":
                        e.scheduleAction("cancel"), h.helper.data("enterResponse", null), h.helper.data("hitMode", null), this._local._setDndStatus(f, e, h.helper, "out", d), t.dragLeave && t.dragLeave(e, u);
                        break;
                    case "stop":
                        x.removeClass("fancytree-drag-source"), a(c).off(".fancytree-dnd"), t.dragStop && t.dragStop(e, u);
                        break;
                    default:
                        a.error("Unsupported drag event: " + b)
                }
                return v
            },
            _cancelDrag: function() {
                var b = a.ui.ddmanager.current;
                b && b.cancel()
            }
        })
    }(jQuery, window, document);

    /*! Extension 'jquery.fancytree.dnd5.min.js' */
    ! function(a, b, c, d) {
        "use strict";

        function e(a) {
            return 0 === a ? "" : a > 0 ? "+" + a : "" + a
        }

        function f(b) {
            var c;
            return !!b && (c = a.isPlainObject(b) ? {
                over: !!b.over,
                before: !!b.before,
                after: !!b.after
            } : a.isArray(b) ? {
                over: a.inArray("over", b) >= 0,
                before: a.inArray("before", b) >= 0,
                after: a.inArray("after", b) >= 0
            } : {
                over: b === !0 || "over" === b,
                before: b === !0 || "before" === b,
                after: b === !0 || "after" === b
            }, 0 !== Object.keys(c).length && c)
        }

        function g(d, e) {
            var f, g, h, i = d.options.dnd5,
                j = d.$scrollParent[0],
                k = i.scrollSensitivity,
                l = i.scrollSpeed,
                m = 0;
            return j !== c && "HTML" !== j.tagName ? (f = d.$scrollParent.offset(), g = j.scrollTop, f.top + j.offsetHeight - e.pageY < k ? (h = j.scrollHeight - d.$scrollParent.innerHeight() - g, h > 0 && (j.scrollTop = m = g + l)) : g > 0 && e.pageY - f.top < k && (j.scrollTop = m = g - l)) : (g = a(c).scrollTop(), g > 0 && e.pageY - g < k ? (m = g - l, a(c).scrollTop(m)) : a(b).height() - (e.pageY - g) < k && (m = g + l, a(c).scrollTop(m))), m && d.debug("autoScroll: " + m + "px"), m
        }

        function h(b, c) {
            if (c.options.dnd5.scroll && g(c.tree, b), !c.node) return c.tree.warn("Ignore dragover for non-node"), u;
            var d, f, h, i = null,
                j = c.tree,
                q = j.options,
                s = q.dnd5,
                v = c.node,
                w = c.otherNode,
                x = "center",
                y = a(v.span),
                z = y.find("span.fancytree-title");
            if (t === !1) return j.warn("Ignore dragover, since dragenter returned false"), !1;
            if ("string" == typeof t ? a.error("assert failed: dragenter returned string") : (f = y.offset(), h = (b.pageY - f.top) / y.height(), t.after && h > .75 ? i = "after" : !t.over && t.after && h > .5 ? i = "after" : t.before && h <= .25 ? i = "before" : !t.over && t.before && h <= .5 ? i = "before" : t.over && (i = "over"), s.preventVoidMoves && (v === w ? (v.debug("drop over source node prevented"), i = null) : "before" === i && w && v === w.getNextSibling() ? (v.debug("drop after source node prevented"), i = null) : "after" === i && w && v === w.getPrevSibling() ? (v.debug("drop before source node prevented"), i = null) : "over" === i && w && w.parent === v && w.isLastSibling() && (v.debug("drop last child over own parent prevented"), i = null))), c.hitMode = i, i && s.dragOver && (s.dragOver(v, c), i = c.hitMode), u = i, "after" === i || "before" === i || "over" === i) {
                switch (d = s.dropMarkerOffsetX || 0, i) {
                    case "before":
                        x = "top", d += s.dropMarkerInsertOffsetX || 0;
                        break;
                    case "after":
                        x = "bottom", d += s.dropMarkerInsertOffsetX || 0
                }
                r.toggleClass(l, "after" === i).toggleClass(n, "over" === i).toggleClass(m, "before" === i).show().position(a.ui.fancytree.fixPositionOptions({
                    my: "left" + e(d) + " center",
                    at: "left " + x,
                    of: z
                }))
            } else r.hide();
            return a(v.span).toggleClass(p, "after" === i || "before" === i || "over" === i).toggleClass(l, "after" === i).toggleClass(m, "before" === i).toggleClass(k, "over" === i).toggleClass(o, i === !1), i
        }
        var i = "fancytree-drag-source",
            j = "fancytree-drag-remove",
            k = "fancytree-drop-accept",
            l = "fancytree-drop-after",
            m = "fancytree-drop-before",
            n = "fancytree-drop-over",
            o = "fancytree-drop-reject",
            p = "fancytree-drop-target",
            q = "application/x-fancytree-node",
            r = null,
            s = null,
            t = null,
            u = null;
        a.ui.fancytree.registerExtension({
            name: "dnd5",
            version: "2.22.4",
            options: {
                autoExpandMS: 1500,
                setTextTypeJson: !1,
                preventForeignNodes: !1,
                preventNonNodes: !1,
                preventRecursiveMoves: !0,
                preventVoidMoves: !0,
                scroll: !0,
                scrollSensitivity: 20,
                scrollSpeed: 5,
                dropMarkerOffsetX: -24,
                dropMarkerInsertOffsetX: -16,
                dragStart: null,
                dragDrag: a.noop,
                dragEnd: a.noop,
                dragEnter: null,
                dragOver: a.noop,
                dragExpand: a.noop,
                dragDrop: a.noop,
                dragLeave: a.noop
            },
            treeInit: function(b) {
                var c = b.tree,
                    e = b.options,
                    g = e.dnd5,
                    l = a.ui.fancytree.getNode;
                a.inArray("dnd", e.extensions) >= 0 && a.error("Extensions 'dnd' and 'dnd5' are mutually exclusive."), g.dragStop && a.error("dragStop is not used by ext-dnd5. Use dragEnd instead."), g.dragStart && a.ui.fancytree.overrideMethod(b.options, "createNode", function(a, b) {
                    this._super.apply(this, arguments), b.node.span.draggable = !0
                }), this._superApply(arguments), this.$container.addClass("fancytree-ext-dnd5"), this.$scrollParent = this.$container.children(":first").scrollParent(), r = a("#fancytree-drop-marker"), r.length || (r = a("<div id='fancytree-drop-marker'></div>").hide().css({
                    "z-index": 1e3,
                    "pointer-events": "none"
                }).prependTo("body")), g.dragStart && c.$container.on("dragstart drag dragend", function(b) {
                    var e, f = l(b),
                        h = b.dataTransfer || b.originalEvent.dataTransfer,
                        k = "move" === h.dropEffect,
                        m = f ? a(f.span) : null,
                        n = {
                            node: f,
                            tree: c,
                            options: c.options,
                            originalEvent: b,
                            dataTransfer: h,
                            isCancelled: d
                        };
                    switch (b.type) {
                        case "dragstart":
                            a(f.span).addClass(i), s = f, e = JSON.stringify(f.toDict());
                            try {
                                h.setData(q, e), h.setData("text/html", a(f.span).html()), h.setData("text/plain", f.title)
                            } catch (o) {
                                c.warn("Could not set data (IE only accepts 'text') - " + o)
                            }
                            return g.setTextTypeJson ? h.setData("text", e) : h.setData("text", f.title), h.effectAllowed = "all", h.setDragImage && h.setDragImage(a(f.span).find(".fancytree-title")[0], -10, -10), g.dragStart(f, n) !== !1;
                        case "drag":
                            m.toggleClass(j, k), g.dragDrag(f, n);
                            break;
                        case "dragend":
                            a(f.span).removeClass(i + " " + j), s = null, t = null, n.isCancelled = "none" === h.dropEffect, r.hide(), g.dragEnd(f, n)
                    }
                }), g.dragEnter && c.$container.on("dragenter dragover dragleave drop", function(b) {
                    var e, i, j, m, p = null,
                        v = l(b),
                        w = b.dataTransfer || b.originalEvent.dataTransfer,
                        x = {
                            node: v,
                            tree: c,
                            options: c.options,
                            hitMode: t,
                            originalEvent: b,
                            dataTransfer: w,
                            otherNode: s || null,
                            otherNodeData: null,
                            dropEffect: d,
                            isCancelled: d
                        };
                    switch (b.type) {
                        case "dragenter":
                            if (!v) {
                                c.debug("Ignore non-node " + b.type + ": " + b.target.tagName + "." + b.target.className), t = !1;
                                break
                            }
                            if (a(v.span).addClass(n).removeClass(k + " " + o), g.preventNonNodes && !i) {
                                v.debug("Reject dropping a non-node"), t = !1;
                                break
                            }
                            if (g.preventForeignNodes && (!s || s.tree !== v.tree)) {
                                v.debug("Reject dropping a foreign node"), t = !1;
                                break
                            }
                            setTimeout(function() {
                                !g.autoExpandMS || v.hasChildren() === !1 || v.expanded || g.dragExpand && g.dragExpand(v, x) === !1 || v.scheduleAction("expand", g.autoExpandMS)
                            }, 0), r.show(), g.preventRecursiveMoves && v.isDescendantOf(x.otherNode) ? m = !1 : (j = g.dragEnter(v, x), m = f(j)), t = m, p = m && (m.over || m.before || m.after);
                            break;
                        case "dragover":
                            u = h(b, x), p = !!u;
                            break;
                        case "dragleave":
                            if (!v) {
                                c.debug("Ignore non-node " + b.type + ": " + b.target.tagName + "." + b.target.className);
                                break
                            }
                            if (!a(v.span).hasClass(n)) {
                                v.debug("Ignore dragleave (multi)");
                                break
                            }
                            a(v.span).removeClass(n + " " + k + " " + o), v.scheduleAction("cancel"), g.dragLeave(v, x), r.hide();
                            break;
                        case "drop":
                            if (a.inArray(q, w.types) >= 0 && (i = w.getData(q), c.info(b.type + ": getData('application/x-fancytree-node'): '" + i + "'")), i || (i = w.getData("text"), c.info(b.type + ": getData('text'): '" + i + "'")), i) try {
                                e = JSON.parse(i), e.title !== d && (x.otherNodeData = e)
                            } catch (y) {}
                            c.debug(b.type + ": nodeData: '" + i + "', otherNodeData: ", x.otherNodeData), a(v.span).removeClass(n + " " + k + " " + o), r.hide(), x.hitMode = u, x.dropEffect = w.dropEffect, x.isCancelled = "none" === x.dropEffect, g.dragDrop(v, x), b.preventDefault()
                    }
                    if (p) return b.preventDefault(), !1
                })
            }
        })
    }(jQuery, window, document);

    /*! Extension 'jquery.fancytree.edit.min.js' */
    ! function(a, b, c, d) {
        "use strict";
        var e = /Mac/.test(navigator.platform),
            f = a.ui.fancytree.escapeHtml,
            g = a.ui.fancytree.unescapeHtml;
        a.ui.fancytree._FancytreeNodeClass.prototype.editStart = function() {
            var b, d = this,
                e = this.tree,
                f = e.ext.edit,
                h = e.options.edit,
                i = a(".fancytree-title", d.span),
                j = {
                    node: d,
                    tree: e,
                    options: e.options,
                    isNew: a(d[e.statusClassPropName]).hasClass("fancytree-edit-new"),
                    orgTitle: d.title,
                    input: null,
                    dirty: !1
                };
            return h.beforeEdit.call(d, {
                type: "beforeEdit"
            }, j) !== !1 && (a.ui.fancytree.assert(!f.currentNode, "recursive edit"), f.currentNode = this, f.eventData = j, e.widget._unbind(), a(c).on("mousedown.fancytree-edit", function(b) {
                a(b.target).hasClass("fancytree-edit-input") || d.editEnd(!0, b)
            }), b = a("<input />", {
                "class": "fancytree-edit-input",
                type: "text",
                value: e.options.escapeTitles ? j.orgTitle : g(j.orgTitle)
            }), f.eventData.input = b, null != h.adjustWidthOfs && b.width(i.width() + h.adjustWidthOfs), null != h.inputCss && b.css(h.inputCss), i.html(b), b.focus().change(function(a) {
                b.addClass("fancytree-edit-dirty")
            }).keydown(function(b) {
                switch (b.which) {
                    case a.ui.keyCode.ESCAPE:
                        d.editEnd(!1, b);
                        break;
                    case a.ui.keyCode.ENTER:
                        return d.editEnd(!0, b), !1
                }
                b.stopPropagation()
            }).blur(function(a) {
                return d.editEnd(!0, a)
            }), void h.edit.call(d, {
                type: "edit"
            }, j))
        }, a.ui.fancytree._FancytreeNodeClass.prototype.editEnd = function(b, d) {
            var e, g = this,
                h = this.tree,
                i = h.ext.edit,
                j = i.eventData,
                k = h.options.edit,
                l = a(".fancytree-title", g.span),
                m = l.find("input.fancytree-edit-input");
            return k.trim && m.val(a.trim(m.val())), e = m.val(), j.dirty = e !== g.title, j.originalEvent = d, b === !1 ? j.save = !1 : j.isNew ? j.save = "" !== e : j.save = j.dirty && "" !== e, k.beforeClose.call(g, {
                type: "beforeClose"
            }, j) !== !1 && ((!j.save || k.save.call(g, {
                type: "save"
            }, j) !== !1) && (m.removeClass("fancytree-edit-dirty").off(), a(c).off(".fancytree-edit"), j.save ? (g.setTitle(h.options.escapeTitles ? e : f(e)), g.setFocus()) : j.isNew ? (g.remove(), g = j.node = null, i.relatedNode.setFocus()) : (g.renderTitle(), g.setFocus()), i.eventData = null, i.currentNode = null, i.relatedNode = null, h.widget._bind(), a(h.$container).focus(), j.input = null, k.close.call(g, {
                type: "close"
            }, j), !0))
        }, a.ui.fancytree._FancytreeNodeClass.prototype.editCreateNode = function(b, c) {
            var d, e = this.tree,
                f = this;
            return b = b || "child", null == c ? c = {
                title: ""
            } : "string" == typeof c ? c = {
                title: c
            } : a.ui.fancytree.assert(a.isPlainObject(c)), "child" !== b || this.isExpanded() || this.hasChildren() === !1 ? (d = this.addNode(c, b), d.match = !0, a(d[e.statusClassPropName]).removeClass("fancytree-hide").addClass("fancytree-match"), void d.makeVisible().done(function() {
                a(d[e.statusClassPropName]).addClass("fancytree-edit-new"), f.tree.ext.edit.relatedNode = f, d.editStart()
            })) : void this.setExpanded().done(function() {
                f.editCreateNode(b, c)
            })
        }, a.ui.fancytree._FancytreeClass.prototype.isEditing = function() {
            return this.ext.edit ? this.ext.edit.currentNode : null
        }, a.ui.fancytree._FancytreeNodeClass.prototype.isEditing = function() {
            return !!this.tree.ext.edit && this.tree.ext.edit.currentNode === this
        }, a.ui.fancytree.registerExtension({
            name: "edit",
            version: "2.22.4",
            options: {
                adjustWidthOfs: 4,
                allowEmpty: !1,
                inputCss: {
                    minWidth: "3em"
                },
                triggerStart: ["f2", "shift+click", "mac+enter"],
                trim: !0,
                beforeClose: a.noop,
                beforeEdit: a.noop,
                close: a.noop,
                edit: a.noop,
                save: a.noop
            },
            currentNode: null,
            treeInit: function(a) {
                this._superApply(arguments), this.$container.addClass("fancytree-ext-edit")
            },
            nodeClick: function(b) {
                return a.inArray("shift+click", b.options.edit.triggerStart) >= 0 && b.originalEvent.shiftKey ? (b.node.editStart(), !1) : this._superApply(arguments)
            },
            nodeDblclick: function(b) {
                return a.inArray("dblclick", b.options.edit.triggerStart) >= 0 ? (b.node.editStart(), !1) : this._superApply(arguments)
            },
            nodeKeydown: function(b) {
                switch (b.originalEvent.which) {
                    case 113:
                        if (a.inArray("f2", b.options.edit.triggerStart) >= 0) return b.node.editStart(), !1;
                        break;
                    case a.ui.keyCode.ENTER:
                        if (a.inArray("mac+enter", b.options.edit.triggerStart) >= 0 && e) return b.node.editStart(), !1
                }
                return this._superApply(arguments)
            }
        })
    }(jQuery, window, document);

    /*! Extension 'jquery.fancytree.filter.min.js' */
    ! function(a, b, c, d) {
        "use strict";

        function e(a) {
            return (a + "").replace(/([.?*+\^\$\[\]\\(){}|-])/g, "\\$1")
        }

        function f(b) {
            return b.indexOf(">") >= 0 ? a("<div/>").html(b).text() : b
        }
        var g = "__not_found__",
            h = a.ui.fancytree.escapeHtml;
        a.ui.fancytree._FancytreeClass.prototype._applyFilterImpl = function(b, c, d) {
            var i, j, k, l, m = 0,
                n = this.options,
                o = n.escapeTitles,
                p = n.autoCollapse,
                q = a.extend({}, n.filter, d),
                r = "hide" === q.mode,
                s = !!q.leavesOnly && !c;
            return "string" == typeof b && (i = q.fuzzy ? b.split("").reduce(function(a, b) {
                return a + "[^" + b + "]*" + b
            }) : e(b), k = new RegExp(".*" + i + ".*", "i"), l = new RegExp(e(b), "gi"), b = function(a) {
                var b, c = o ? a.title : f(a.title),
                    d = !!k.test(c);
                return d && q.highlight && (b = o ? h(a.title) : c, a.titleWithHighlight = b.replace(l, function(a) {
                    return "<mark>" + a + "</mark>"
                })), d
            }), this.enableFilter = !0, this.lastFilterArgs = arguments, this.$div.addClass("fancytree-ext-filter"), r ? this.$div.addClass("fancytree-ext-filter-hide") : this.$div.addClass("fancytree-ext-filter-dimm"), this.$div.toggleClass("fancytree-ext-filter-hide-expanders", !!q.hideExpanders), this.visit(function(a) {
                delete a.match, delete a.titleWithHighlight, a.subMatchCount = 0
            }), j = this.getRootNode()._findDirectChild(g), j && j.remove(), n.autoCollapse = !1, this.visit(function(a) {
                if (!s || null == a.children) {
                    var d = b(a),
                        e = !1;
                    if ("skip" === d) return a.visit(function(a) {
                        a.match = !1
                    }, !0), "skip";
                    d || !c && "branch" !== d || !a.parent.match || (d = !0, e = !0), d && (m++, a.match = !0, a.visitParents(function(a) {
                        a.subMatchCount += 1, !q.autoExpand || e || a.expanded || (a.setExpanded(!0, {
                            noAnimation: !0,
                            noEvents: !0,
                            scrollIntoView: !1
                        }), a._filterAutoExpanded = !0)
                    }))
                }
            }), n.autoCollapse = p, 0 === m && q.nodata && r && (j = q.nodata, a.isFunction(j) && (j = j()), j === !0 ? j = {} : "string" == typeof j && (j = {
                title: j
            }), j = a.extend({
                statusNodeType: "nodata",
                key: g,
                title: this.options.strings.noData
            }, j), this.getRootNode().addNode(j).match = !0), this.render(), m
        }, a.ui.fancytree._FancytreeClass.prototype.filterNodes = function(a, b) {
            return "boolean" == typeof b && (b = {
                leavesOnly: b
            }, this.warn("Fancytree.filterNodes() leavesOnly option is deprecated since 2.9.0 / 2015-04-19. Use opts.leavesOnly instead.")), this._applyFilterImpl(a, !1, b)
        }, a.ui.fancytree._FancytreeClass.prototype.applyFilter = function(a) {
            return this.warn("Fancytree.applyFilter() is deprecated since 2.1.0 / 2014-05-29. Use .filterNodes() instead."), this.filterNodes.apply(this, arguments)
        }, a.ui.fancytree._FancytreeClass.prototype.filterBranches = function(a, b) {
            return this._applyFilterImpl(a, !0, b)
        }, a.ui.fancytree._FancytreeClass.prototype.clearFilter = function() {
            var b, c = this.getRootNode()._findDirectChild(g),
                d = this.options.escapeTitles,
                e = this.options.enhanceTitle;
            c && c.remove(), this.visit(function(c) {
                c.match && c.span && (b = a(c.span).find(">span.fancytree-title"), d ? b.text(c.title) : b.html(c.title), e && e({
                    type: "enhanceTitle"
                }, {
                    node: c,
                    $title: b
                })), delete c.match, delete c.subMatchCount, delete c.titleWithHighlight, c.$subMatchBadge && (c.$subMatchBadge.remove(), delete c.$subMatchBadge), c._filterAutoExpanded && c.expanded && c.setExpanded(!1, {
                    noAnimation: !0,
                    noEvents: !0,
                    scrollIntoView: !1
                }), delete c._filterAutoExpanded
            }), this.enableFilter = !1, this.lastFilterArgs = null, this.$div.removeClass("fancytree-ext-filter fancytree-ext-filter-dimm fancytree-ext-filter-hide"), this.render()
        }, a.ui.fancytree._FancytreeClass.prototype.isFilterActive = function() {
            return !!this.enableFilter
        }, a.ui.fancytree._FancytreeNodeClass.prototype.isMatched = function() {
            return !(this.tree.enableFilter && !this.match)
        }, a.ui.fancytree.registerExtension({
            name: "filter",
            version: "2.22.4",
            options: {
                autoApply: !0,
                autoExpand: !1,
                counter: !0,
                fuzzy: !1,
                hideExpandedCounter: !0,
                hideExpanders: !1,
                highlight: !0,
                leavesOnly: !1,
                nodata: !0,
                mode: "dimm"
            },
            nodeLoadChildren: function(a, b) {
                return this._superApply(arguments).done(function() {
                    a.tree.enableFilter && a.tree.lastFilterArgs && a.options.filter.autoApply && a.tree._applyFilterImpl.apply(a.tree, a.tree.lastFilterArgs)
                })
            },
            nodeSetExpanded: function(a, b, c) {
                return delete a.node._filterAutoExpanded, !b && a.options.filter.hideExpandedCounter && a.node.$subMatchBadge && a.node.$subMatchBadge.show(), this._superApply(arguments)
            },
            nodeRenderStatus: function(b) {
                var c, d = b.node,
                    e = b.tree,
                    f = b.options.filter,
                    g = a(d.span).find("span.fancytree-title"),
                    h = a(d[e.statusClassPropName]),
                    i = b.options.enhanceTitle,
                    j = b.options.escapeTitles;
                return c = this._super(b), h.length && e.enableFilter ? (h.toggleClass("fancytree-match", !!d.match).toggleClass("fancytree-submatch", !!d.subMatchCount).toggleClass("fancytree-hide", !(d.match || d.subMatchCount)), !f.counter || !d.subMatchCount || d.isExpanded() && f.hideExpandedCounter ? d.$subMatchBadge && d.$subMatchBadge.hide() : (d.$subMatchBadge || (d.$subMatchBadge = a("<span class='fancytree-childcounter'/>"), a("span.fancytree-icon, span.fancytree-custom-icon", d.span).append(d.$subMatchBadge)), d.$subMatchBadge.show().text(d.subMatchCount)), !d.span || d.isEditing && d.isEditing.call(d) || (d.titleWithHighlight ? g.html(d.titleWithHighlight) : j ? g.text(d.title) : g.html(d.title), i && i({
                    type: "enhanceTitle"
                }, {
                    node: d,
                    $title: g
                })), c) : c
            }
        })
    }(jQuery, window, document);

    /*! Extension 'jquery.fancytree.glyph.min.js' */
    ! function(a, b, c, d) {
        "use strict";

        function e(a, b) {
            return a.map[b]
        }
        a.ui.fancytree.registerExtension({
            name: "glyph",
            version: "2.22.4",
            options: {
                map: {
                    checkbox: "icon-check-empty",
                    checkboxSelected: "icon-check",
                    checkboxUnknown: "icon-check icon-muted",
                    error: "icon-exclamation-sign",
                    expanderClosed: "icon-caret-right",
                    expanderLazy: "icon-angle-right",
                    expanderOpen: "icon-caret-down",
                    nodata: "icon-meh",
                    noExpander: "",
                    dragHelper: "icon-caret-right",
                    dropMarker: "icon-caret-right",
                    doc: "icon-file-alt",
                    docOpen: "icon-file-alt",
                    loading: "icon-refresh icon-spin",
                    folder: "icon-folder-close-alt",
                    folderOpen: "icon-folder-open-alt"
                }
            },
            treeInit: function(a) {
                var b = a.tree;
                this._superApply(arguments), b.$container.addClass("fancytree-ext-glyph")
            },
            nodeRenderStatus: function(b) {
                var c, d, f, g = b.node,
                    h = a(g.span),
                    i = b.options.glyph,
                    j = i.map;
                return d = this._super(b), g.isRoot() ? d : (f = h.children("span.fancytree-expander").get(0), f && (c = g.expanded && g.hasChildren() ? "expanderOpen" : g.isUndefined() ? "expanderLazy" : g.hasChildren() ? "expanderClosed" : "noExpander", f.className = "fancytree-expander " + j[c]), f = g.tr ? a("td", g.tr).find("span.fancytree-checkbox").get(0) : h.children("span.fancytree-checkbox").get(0), f && (c = g.selected ? "checkboxSelected" : g.partsel ? "checkboxUnknown" : "checkbox", f.className = "fancytree-checkbox " + j[c]), f = h.children("span.fancytree-icon").get(0), f && (c = g.statusNodeType ? e(i, g.statusNodeType) : g.folder ? g.expanded && g.hasChildren() ? e(i, "folderOpen") : e(i, "folder") : g.expanded ? e(i, "docOpen") : e(i, "doc"), f.className = "fancytree-icon " + c), d)
            },
            nodeSetStatus: function(b, c, d, f) {
                var g, h, i = b.options.glyph,
                    j = b.node;
                return g = this._superApply(arguments), "error" !== c && "loading" !== c && "nodata" !== c || (j.parent ? (h = a("span.fancytree-expander", j.span).get(0), h && (h.className = "fancytree-expander " + e(i, c))) : (h = a(".fancytree-statusnode-" + c, j[this.nodeContainerAttrName]).find("span.fancytree-icon").get(0), h && (h.className = "fancytree-icon " + e(i, c)))), g
            }
        })
    }(jQuery, window, document);

    /*! Extension 'jquery.fancytree.gridnav.min.js' */
    ! function(a, b, c, d) {
        "use strict";

        function e(b, c) {
            var d, e = c.get(0),
                f = 0;
            return b.children().each(function() {
                return this !== e && (d = a(this).prop("colspan"), void(f += d ? d : 1))
            }), f
        }

        function f(b, c) {
            var d, e = null,
                f = 0;
            return b.children().each(function() {
                return f >= c ? (e = a(this), !1) : (d = a(this).prop("colspan"), void(f += d ? d : 1))
            }), e
        }

        function g(a, b) {
            var c, d, g = a.closest("td"),
                i = null;
            switch (b) {
                case h.LEFT:
                    i = g.prev();
                    break;
                case h.RIGHT:
                    i = g.next();
                    break;
                case h.UP:
                case h.DOWN:
                    for (c = g.parent(), d = e(c, g);;) {
                        if (c = b === h.UP ? c.prev() : c.next(), !c.length) break;
                        if (!c.is(":hidden") && (i = f(c, d), i && i.find(":input,a").length)) break
                    }
            }
            return i
        }
        var h = a.ui.keyCode,
            i = {
                text: [h.UP, h.DOWN],
                checkbox: [h.UP, h.DOWN, h.LEFT, h.RIGHT],
                link: [h.UP, h.DOWN, h.LEFT, h.RIGHT],
                radiobutton: [h.UP, h.DOWN, h.LEFT, h.RIGHT],
                "select-one": [h.LEFT, h.RIGHT],
                "select-multiple": [h.LEFT, h.RIGHT]
            };
        a.ui.fancytree.registerExtension({
            name: "gridnav",
            version: "2.22.4",
            options: {
                autofocusInput: !1,
                handleCursorKeys: !0
            },
            treeInit: function(b) {
                this._requireExtension("table", !0, !0), this._superApply(arguments), this.$container.addClass("fancytree-ext-gridnav"), this.$container.on("focusin", function(c) {
                    var d, e = a.ui.fancytree.getNode(c.target);
                    e && !e.isActive() && (d = b.tree._makeHookContext(e, c), b.tree._callHook("nodeSetActive", d, !0))
                })
            },
            nodeSetActive: function(b, c, d) {
                var e, f = b.options.gridnav,
                    g = b.node,
                    h = b.originalEvent || {},
                    i = a(h.target).is(":input");
                c = c !== !1, this._superApply(arguments), c && (b.options.titlesTabbable ? (i || (a(g.span).find("span.fancytree-title").focus(), g.setFocus()), b.tree.$container.attr("tabindex", "-1")) : f.autofocusInput && !i && (e = a(g.tr || g.span), e.find(":input:enabled:first").focus()))
            },
            nodeKeydown: function(b) {
                var c, d, e, f = b.options.gridnav,
                    h = b.originalEvent,
                    j = a(h.target);
                return j.is(":input:enabled") ? c = j.prop("type") : j.is("a") && (c = "link"), c && f.handleCursorKeys ? (d = i[c], !(d && a.inArray(h.which, d) >= 0 && (e = g(j, h.which), e && e.length)) || (e.find(":input:enabled,a").focus(), !1)) : this._superApply(arguments)
            }
        })
    }(jQuery, window, document);

    /*! Extension 'jquery.fancytree.persist.min.js' */
    ! function(a, b, c, d) {
        "use strict";

        function e(b, c, d, f, g) {
            var h, i, j, l, m = !1,
                n = b.options.persist.expandOpts,
                o = [],
                p = [];
            for (d = d || [], g = g || a.Deferred(), h = 0, j = d.length; h < j; h++) i = d[h], l = b.getNodeByKey(i), l ? f && l.isUndefined() ? (m = !0, b.debug("_loadLazyNodes: " + l + " is lazy: loading..."), "expand" === f ? o.push(l.setExpanded(!0, n)) : o.push(l.load())) : (b.debug("_loadLazyNodes: " + l + " already loaded."), l.setExpanded(!0, n)) : (p.push(i), b.debug("_loadLazyNodes: " + l + " was not yet found."));
            return a.when.apply(a, o).always(function() {
                if (m && p.length > 0) e(b, c, p, f, g);
                else {
                    if (p.length)
                        for (b.warn("_loadLazyNodes: could not load those keys: ", p), h = 0, j = p.length; h < j; h++) i = d[h], c._appendKey(k, d[h], !1);
                    g.resolve()
                }
            }), g
        }
        var f, g, h, i = a.ui.fancytree.assert,
            j = "active",
            k = "expanded",
            l = "focus",
            m = "selected";
        "function" == typeof Cookies ? (h = Cookies.set, f = Cookies.get, g = Cookies.remove) : (h = f = a.cookie, g = a.removeCookie), a.ui.fancytree._FancytreeClass.prototype.clearCookies = function(a) {
            var b = this.ext.persist,
                c = b.cookiePrefix;
            a = a || "active expanded focus selected", a.indexOf(j) >= 0 && b._data(c + j, null), a.indexOf(k) >= 0 && b._data(c + k, null), a.indexOf(l) >= 0 && b._data(c + l, null), a.indexOf(m) >= 0 && b._data(c + m, null)
        }, a.ui.fancytree._FancytreeClass.prototype.getPersistData = function() {
            var a = this.ext.persist,
                b = a.cookiePrefix,
                c = a.cookieDelimiter,
                d = {};
            return d[j] = a._data(b + j), d[k] = (a._data(b + k) || "").split(c), d[m] = (a._data(b + m) || "").split(c), d[l] = a._data(b + l), d
        }, a.ui.fancytree.registerExtension({
            name: "persist",
            version: "2.22.4",
            options: {
                cookieDelimiter: "~",
                cookiePrefix: d,
                cookie: {
                    raw: !1,
                    expires: "",
                    path: "",
                    domain: "",
                    secure: !1
                },
                expandLazy: !1,
                expandOpts: d,
                fireActivate: !0,
                overrideSource: !0,
                store: "auto",
                types: "active expanded focus selected"
            },
            _data: function(a, b) {
                var c = this._local.localStorage;
                return b === d ? c ? c.getItem(a) : f(a) : void(null === b ? c ? c.removeItem(a) : g(a) : c ? c.setItem(a, b) : h(a, b, this.options.persist.cookie))
            },
            _appendKey: function(b, c, d) {
                c = "" + c;
                var e = this._local,
                    f = this.options.persist,
                    g = f.cookieDelimiter,
                    h = e.cookiePrefix + b,
                    i = e._data(h),
                    j = i ? i.split(g) : [],
                    k = a.inArray(c, j);
                k >= 0 && j.splice(k, 1), d && j.push(c), e._data(h, j.join(g))
            },
            treeInit: function(c) {
                var g = c.tree,
                    h = c.options,
                    n = this._local,
                    o = this.options.persist;
                return i("auto" !== o.store && "cookie" !== o.store || f, "Missing required plugin for 'persist' extension: js.cookie.js or jquery.cookie.js"), n.cookiePrefix = o.cookiePrefix || "fancytree-" + g._id + "-", n.storeActive = o.types.indexOf(j) >= 0, n.storeExpanded = o.types.indexOf(k) >= 0, n.storeSelected = o.types.indexOf(m) >= 0, n.storeFocus = o.types.indexOf(l) >= 0, "cookie" !== o.store && b.localStorage ? n.localStorage = "local" === o.store ? b.localStorage : b.sessionStorage : n.localStorage = null, g.$div.bind("fancytreeinit", function(b) {
                    if (g._triggerTreeEvent("beforeRestore", null, {}) !== !1) {
                        var c, f, i, p, q, r = n._data(n.cookiePrefix + l),
                            s = o.fireActivate === !1;
                        c = n._data(n.cookiePrefix + k), p = c && c.split(o.cookieDelimiter), f = n.storeExpanded ? e(g, n, p, !!o.expandLazy && "expand", null) : (new a.Deferred).resolve(), f.done(function() {
                            if (n.storeSelected) {
                                if (c = n._data(n.cookiePrefix + m))
                                    for (p = c.split(o.cookieDelimiter), i = 0; i < p.length; i++) q = g.getNodeByKey(p[i]), q ? (q.selected === d || o.overrideSource && q.selected === !1) && (q.selected = !0, q.renderStatus()) : n._appendKey(m, p[i], !1);
                                3 === g.options.selectMode && g.visit(function(a) {
                                    if (a.selected) return a.fixSelection3AfterClick(), "skip"
                                })
                            }
                            n.storeActive && (c = n._data(n.cookiePrefix + j), !c || !h.persist.overrideSource && g.activeNode || (q = g.getNodeByKey(c), q && (q.debug("persist: set active", c), q.setActive(!0, {
                                noFocus: !0,
                                noEvents: s
                            })))), n.storeFocus && r && (q = g.getNodeByKey(r), q && (g.options.titlesTabbable ? a(q.span).find(".fancytree-title").focus() : a(g.$container).focus())), g._triggerTreeEvent("restore", null, {})
                        })
                    }
                }), this._superApply(arguments)
            },
            nodeSetActive: function(a, b, c) {
                var d, e = this._local;
                return b = b !== !1, d = this._superApply(arguments), e.storeActive && e._data(e.cookiePrefix + j, this.activeNode ? this.activeNode.key : null), d
            },
            nodeSetExpanded: function(a, b, c) {
                var d, e = a.node,
                    f = this._local;
                return b = b !== !1, d = this._superApply(arguments), f.storeExpanded && f._appendKey(k, e.key, b), d
            },
            nodeSetFocus: function(a, b) {
                var c, d = this._local;
                return b = b !== !1, c = this._superApply(arguments), d.storeFocus && d._data(d.cookiePrefix + l, this.focusNode ? this.focusNode.key : null), c
            },
            nodeSetSelected: function(b, c) {
                var d, e, f = b.tree,
                    g = b.node,
                    h = this._local;
                return c = c !== !1, d = this._superApply(arguments), h.storeSelected && (3 === f.options.selectMode ? (e = a.map(f.getSelectedNodes(!0), function(a) {
                    return a.key
                }), e = e.join(b.options.persist.cookieDelimiter), h._data(h.cookiePrefix + m, e)) : h._appendKey(m, g.key, g.selected)), d
            }
        })
    }(jQuery, window, document);

    /*! Extension 'jquery.fancytree.table.min.js' */
    ! function(a, b, c, d) {
        "use strict";

        function e(b, c) {
            c = c || "", b || a.error("Assertion failed " + c)
        }

        function f(a, b) {
            a.insertBefore(b, a.firstChild)
        }

        function g(a, b) {
            a.parentNode.insertBefore(b, a.nextSibling)
        }

        function h(a, b) {
            a.visit(function(a) {
                var c = a.tr;
                if (c && (c.style.display = a.hide || !b ? "none" : ""), !a.expanded) return "skip"
            })
        }

        function i(b) {
            var c, d, f, g = b.parent,
                h = g ? g.children : null;
            if (h && h.length > 1 && h[0] !== b)
                for (c = a.inArray(b, h), f = h[c - 1], e(f.tr); f.children && f.children.length && (d = f.children[f.children.length - 1], d.tr);) f = d;
            else f = g;
            return f
        }
        a.ui.fancytree.registerExtension({
            name: "table",
            version: "2.22.4",
            options: {
                checkboxColumnIdx: null,
                indentation: 16,
                nodeColumnIdx: 0
            },
            treeInit: function(b) {
                var d, f, g, h, i, j = b.tree,
                    k = b.options,
                    l = k.table,
                    m = j.widget.element;
                if (null != l.customStatus && (null != k.renderStatusColumns ? a.error("The 'customStatus' option is deprecated since v2.15.0. Use 'renderStatusColumns' only instead.") : (j.warn("The 'customStatus' option is deprecated since v2.15.0. Use 'renderStatusColumns' instead."), k.renderStatusColumns = l.customStatus)), k.renderStatusColumns && k.renderStatusColumns === !0 && (k.renderStatusColumns = k.renderColumns), m.addClass("fancytree-container fancytree-ext-table"), j.tbody = m.find(">tbody")[0], i = a(j.tbody), f = a("thead >tr:last >th", m).length, h = i.children("tr:first"), h.length) g = h.children("td").length, f && g !== f && (j.warn("Column count mismatch between thead (" + f + ") and tbody (" + g + "): using tbody."), f = g), h = h.clone();
                else
                    for (e(f >= 1, "Need either <thead> or <tbody> with <td> elements to determine column count."), h = a("<tr />"), d = 0; d < f; d++) h.append("<td />");
                h.find(">td").eq(l.nodeColumnIdx).html("<span class='fancytree-node' />"), k.aria && (h.attr("role", "row"), h.find("td").attr("role", "gridcell")), j.rowFragment = c.createDocumentFragment(), j.rowFragment.appendChild(h.get(0)), i.empty(), j.statusClassPropName = "tr", j.ariaPropName = "tr", this.nodeContainerAttrName = "tr", j.$container = m, this._superApply(arguments), a(j.rootNode.ul).remove(), j.rootNode.ul = null, this.$container.attr("tabindex", k.tabindex), k.aria && j.$container.attr("role", "treegrid").attr("aria-readonly", !0)
            },
            nodeRemoveChildMarkup: function(b) {
                var c = b.node;
                c.visit(function(b) {
                    b.tr && (a(b.tr).remove(), b.tr = null)
                })
            },
            nodeRemoveMarkup: function(b) {
                var c = b.node;
                c.tr && (a(c.tr).remove(), c.tr = null), this.nodeRemoveChildMarkup(b)
            },
            nodeRender: function(b, c, d, j, k) {
                var l, m, n, o, p, q, r, s, t = b.tree,
                    u = b.node,
                    v = b.options,
                    w = !u.parent;
                if (t._enableUpdate !== !1) {
                    if (k || (b.hasCollapsedParents = u.parent && !u.parent.expanded), !w)
                        if (u.tr && c && this.nodeRemoveMarkup(b), u.tr) c ? this.nodeRenderTitle(b) : this.nodeRenderStatus(b);
                        else {
                            if (b.hasCollapsedParents && !d) return void u.debug("nodeRender ignored due to unrendered parent");
                            p = t.rowFragment.firstChild.cloneNode(!0), q = i(u), e(q), j === !0 && k ? p.style.display = "none" : d && b.hasCollapsedParents && (p.style.display = "none"), q.tr ? g(q.tr, p) : (e(!q.parent, "prev. row must have a tr, or be system root"), f(t.tbody, p)), u.tr = p, u.key && v.generateIds && (u.tr.id = v.idPrefix + u.key), u.tr.ftnode = u, u.span = a("span.fancytree-node", u.tr).get(0), this.nodeRenderTitle(b), v.createNode && v.createNode.call(t, {
                                type: "createNode"
                            }, b)
                        } if (v.renderNode && v.renderNode.call(t, {
                            type: "renderNode"
                        }, b), l = u.children, l && (w || d || u.expanded))
                        for (n = 0, o = l.length; n < o; n++) s = a.extend({}, b, {
                            node: l[n]
                        }), s.hasCollapsedParents = s.hasCollapsedParents || !u.expanded, this.nodeRender(s, c, d, j, !0);
                    l && !k && (r = u.tr || null, m = t.tbody.firstChild, u.visit(function(a) {
                        if (a.tr) {
                            if (a.parent.expanded || "none" === a.tr.style.display || (a.tr.style.display = "none", h(a, !1)), a.tr.previousSibling !== r) {
                                u.debug("_fixOrder: mismatch at node: " + a);
                                var b = r ? r.nextSibling : m;
                                t.tbody.insertBefore(a.tr, b)
                            }
                            r = a.tr
                        }
                    }))
                }
            },
            nodeRenderTitle: function(b, c) {
                var d, e, f = b.node,
                    g = b.options,
                    h = f.isStatusNode();
                return e = this._super(b, c), f.isRootNode() ? e : (g.checkbox && !h && null != g.table.checkboxColumnIdx && (d = a("span.fancytree-checkbox", f.span), a(f.tr).find("td").eq(+g.table.checkboxColumnIdx).html(d)), this.nodeRenderStatus(b), h ? g.renderStatusColumns && g.renderStatusColumns.call(b.tree, {
                    type: "renderStatusColumns"
                }, b) : g.renderColumns && g.renderColumns.call(b.tree, {
                    type: "renderColumns"
                }, b), e)
            },
            nodeRenderStatus: function(b) {
                var c, d = b.node,
                    e = b.options;
                this._super(b), a(d.tr).removeClass("fancytree-node"), c = (d.getLevel() - 1) * e.table.indentation, a(d.span).css({
                    paddingLeft: c + "px"
                })
            },
            nodeSetExpanded: function(b, c, d) {
                function e(a) {
                    h(b.node, c), a ? c && b.options.autoScroll && !d.noAnimation && b.node.hasChildren() ? b.node.getLastChild().scrollIntoView(!0, {
                        topNode: b.node
                    }).always(function() {
                        d.noEvents || b.tree._triggerNodeEvent(c ? "expand" : "collapse", b), f.resolveWith(b.node)
                    }) : (d.noEvents || b.tree._triggerNodeEvent(c ? "expand" : "collapse", b), f.resolveWith(b.node)) : (d.noEvents || b.tree._triggerNodeEvent(c ? "expand" : "collapse", b), f.rejectWith(b.node))
                }
                if (c = c !== !1, b.node.expanded && c || !b.node.expanded && !c) return this._superApply(arguments);
                var f = new a.Deferred,
                    g = a.extend({}, d, {
                        noEvents: !0,
                        noAnimation: !0
                    });
                return d = d || {}, this._super(b, c, g).done(function() {
                    e(!0)
                }).fail(function() {
                    e(!1)
                }), f.promise()
            },
            nodeSetStatus: function(b, c, d, e) {
                if ("ok" === c) {
                    var f = b.node,
                        g = f.children ? f.children[0] : null;
                    g && g.isStatusNode() && a(g.tr).remove()
                }
                return this._superApply(arguments)
            },
            treeClear: function(a) {
                return this.nodeRemoveChildMarkup(this._makeHookContext(this.rootNode)), this._superApply(arguments)
            },
            treeDestroy: function(a) {
                return this.$container.find("tbody").empty(), this.$source && this.$source.removeClass("ui-helper-hidden"), this._superApply(arguments)
            }
        })
    }(jQuery, window, document);

    /*! Extension 'jquery.fancytree.themeroller.min.js' */
    ! function(a, b, c, d) {
        "use strict";
        a.ui.fancytree.registerExtension({
            name: "themeroller",
            version: "2.22.4",
            options: {
                activeClass: "ui-state-active",
                addClass: "ui-corner-all",
                focusClass: "ui-state-focus",
                hoverClass: "ui-state-hover",
                selectedClass: "ui-state-highlight"
            },
            treeInit: function(b) {
                var c = b.widget.element,
                    d = b.options.themeroller;
                this._superApply(arguments), "TABLE" === c[0].nodeName ? (c.addClass("ui-widget ui-corner-all"), c.find(">thead tr").addClass("ui-widget-header"), c.find(">tbody").addClass("ui-widget-conent")) : c.addClass("ui-widget ui-widget-content ui-corner-all"), c.delegate(".fancytree-node", "mouseenter mouseleave", function(b) {
                    var c = a.ui.fancytree.getNode(b.target),
                        e = "mouseenter" === b.type;
                    a(c.tr ? c.tr : c.span).toggleClass(d.hoverClass + " " + d.addClass, e)
                })
            },
            treeDestroy: function(a) {
                this._superApply(arguments), a.widget.element.removeClass("ui-widget ui-widget-content ui-corner-all")
            },
            nodeRenderStatus: function(b) {
                var c = {},
                    d = b.node,
                    e = a(d.tr ? d.tr : d.span),
                    f = b.options.themeroller;
                this._super(b), c[f.activeClass] = !1, c[f.focusClass] = !1, c[f.selectedClass] = !1, d.isActive() && (c[f.activeClass] = !0), d.hasFocus() && (c[f.focusClass] = !0), d.isSelected() && !d.isActive() && (c[f.selectedClass] = !0), e.toggleClass(f.activeClass, c[f.activeClass]), e.toggleClass(f.focusClass, c[f.focusClass]), e.toggleClass(f.selectedClass, c[f.selectedClass]), e.addClass(f.addClass)
            }
        })
    }(jQuery, window, document);

    /*! Extension 'jquery.fancytree.wide.min.js' */
    ! function(a, b, c, d) {
        "use strict";

        function e(b, c) {
            b = "fancytree-style-" + b;
            var d = a("#" + b);
            if (!c) return d.remove(), null;
            d.length || (d = a("<style />").attr("id", b).addClass("fancytree-style").prop("type", "text/css").appendTo("head"));
            try {
                d.html(c)
            } catch (e) {
                d[0].styleSheet.cssText = c
            }
            return d
        }

        function f(a, b, c, d, e, f) {
            var g, h = "#" + a + " span.fancytree-level-",
                i = [];
            for (g = 0; g < b; g++) i.push(h + (g + 1) + " span.fancytree-title { padding-left: " + (g * c + d) + f + "; }");
            return i.push("#" + a + " div.ui-effects-wrapper ul li span.fancytree-title, #" + a + " ul.fancytree-animating span.fancytree-title { padding-left: " + e + f + "; position: static; width: auto; }"), i.join("\n")
        }
        var g = /^([+-]?(?:\d+|\d*\.\d+))([a-z]*|%)$/;
        a.ui.fancytree.registerExtension({
            name: "wide",
            version: "2.22.4",
            options: {
                iconWidth: null,
                iconSpacing: null,
                labelSpacing: null,
                levelOfs: null
            },
            treeCreate: function(b) {
                this._superApply(arguments), this.$container.addClass("fancytree-ext-wide");
                var c, d, h, i, j, k, l = b.options.wide,
                    m = a("<li id='fancytreeTemp'><span class='fancytree-node'><span class='fancytree-icon' /><span class='fancytree-title' /></span><ul />").appendTo(b.tree.$container),
                    n = m.find(".fancytree-icon"),
                    o = m.find("ul"),
                    p = l.iconSpacing || n.css("margin-left"),
                    q = l.iconWidth || n.css("width"),
                    r = l.labelSpacing || "3px",
                    s = l.levelOfs || o.css("padding-left");
                m.remove(), h = p.match(g)[2], p = parseFloat(p, 10), i = r.match(g)[2], r = parseFloat(r, 10), j = q.match(g)[2], q = parseFloat(q, 10), k = s.match(g)[2], h === j && k === j && i === j || a.error("iconWidth, iconSpacing, and levelOfs must have the same css measure unit"), this._local.measureUnit = j, this._local.levelOfs = parseFloat(s), this._local.lineOfs = (1 + (b.options.checkbox ? 1 : 0) + (b.options.icon === !1 ? 0 : 1)) * (q + p) + p, this._local.labelOfs = r, this._local.maxDepth = 10, c = this.$container.uniqueId().attr("id"), d = f(c, this._local.maxDepth, this._local.levelOfs, this._local.lineOfs, this._local.labelOfs, this._local.measureUnit), e(c, d)
            },
            treeDestroy: function(a) {
                return e(this.$container.attr("id"), null), this._superApply(arguments)
            },
            nodeRenderStatus: function(b) {
                var c, d, g, h = b.node,
                    i = h.getLevel();
                return g = this._super(b), i > this._local.maxDepth && (c = this.$container.attr("id"), this._local.maxDepth *= 2, h.debug("Define global ext-wide css up to level " + this._local.maxDepth), d = f(c, this._local.maxDepth, this._local.levelOfs, this._local.lineOfs, this._local.labelSpacing, this._local.measureUnit), e(c, d)), a(h.span).addClass("fancytree-level-" + i), g
            }
        })
    }(jQuery, window, document);
}));