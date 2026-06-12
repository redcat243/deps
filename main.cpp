#include <iostream>
#include <string>
#include <unistd.h>
#include <limits.h>
#include <stdlib.h>
#include <string.h>
#include <gtk/gtk.h>

#define WEBVIEW_IMPLEMENTATION
#define WEBVIEW_GTK
#include "webview.h"

std::string get_executable_dir() {
    char result[PATH_MAX];
    ssize_t count = readlink("/proc/self/exe", result, PATH_MAX);
    if (count != -1) {
        std::string fullPath(result, count);
        size_t lastSlash = fullPath.find_last_of("/");
        if (lastSlash != std::string::npos) {
            return fullPath.substr(0, lastSlash);
        }
    }
    return ".";
}

void on_cat_button_clicked(GtkWidget *widget, gpointer data) {
    struct webview *w = (struct webview *)data;
    std::string exeDir = get_executable_dir();
    std::string homePath = "file://" + exeDir + "/cathome.html";
    webview_navigate(w, homePath.c_str());
}

int main() {
    std::string exeDir = get_executable_dir();
    std::string homePath = "file://" + exeDir + "/cathome.html";
    std::string aboutPath = "file://" + exeDir + "/about.html";
    
    struct webview w;
    memset(&w, 0, sizeof(w));
    w.title = "CatBrowser - better for your computer";
    w.width = 1200;
    w.height = 800;
    w.resizable = 1;
    w.url = homePath.c_str();

    if (webview_init(&w) != 0) return 1;

    GtkWidget *window = (GtkWidget *)w.priv.window;
    GtkWidget *box = gtk_bin_get_child(GTK_BIN(window));
    if (GTK_IS_BOX(box)) {
        GtkWidget *toolbar = gtk_toolbar_new();
        GtkToolItem *cat_btn = gtk_tool_button_new(NULL, "Cat (Home)");
        gtk_toolbar_insert(GTK_TOOLBAR(toolbar), cat_btn, 0);
        gtk_box_pack_start(GTK_BOX(box), toolbar, FALSE, FALSE, 0);
        gtk_box_reorder_child(GTK_BOX(box), toolbar, 0);
        g_signal_connect(G_OBJECT(cat_btn), "clicked", G_CALLBACK(on_cat_button_clicked), &w);
        gtk_widget_show_all(toolbar);
    }

    std::string js = "window.oncontextmenu = function(e) {\n"
                     "  e.preventDefault();\n"
                     "  var c = prompt('1:HOME, 2:GOOGLE, 3:OIIA, 4:BACK');\n"
                     "  if (c == '1') { location.href = \"" + homePath + "\"; }\n"
                     "  if (c == '2') { location.href = \"https://google.com\"; }\n"
                     "  if (c == '3') { location.href = \"https://youtube.com\"; }\n"
                     "  if (c == '4') { history.back(); }\n"
                     "};";
    webview_eval(&w, js.c_str());

    struct webview w_about;
    memset(&w_about, 0, sizeof(w_about));
    w_about.title = "About CatBrowser";
    w_about.width = 500;
    w_about.height = 600;
    w_about.resizable = 1;
    w_about.url = aboutPath.c_str();

    if (webview_init(&w_about) == 0) {
        g_signal_handlers_disconnect_by_func(w_about.priv.window, (gpointer)webview_exit, &w_about);
    }

    while (webview_loop(&w, 1) == 0) {
        if (w_about.priv.window) {
            webview_loop(&w_about, 0);
        }
    }
    
    webview_exit(&w);
    return 0;
}
