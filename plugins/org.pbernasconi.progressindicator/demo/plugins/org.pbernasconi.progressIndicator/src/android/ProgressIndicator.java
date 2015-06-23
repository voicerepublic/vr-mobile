package org.apache.cordova.plugin;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import android.app.ProgressDialog;

public class ProgressIndicator extends CordovaPlugin {

    private ProgressDialog progressIndicator = null;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("show")) {
            String text = args.getString(0);
            show(text);
            callbackContext.success();
            return true;
        } else if (action.equals("hide")) {
            hide();
            callbackContext.success();
            return true;
        }

        return false;
    }

    /**
     * This show the ProgressDialog
     *
     * @param text - Message to display in the Progress Dialog
     */
    public void show(String text) {
        progressIndicator = ProgressDialog.show(this.cordova.getActivity(), "", text);
    }

    /**
     * This hide the ProgressDialog
     */
    public void hide() {
        if (progressIndicator != null) {
            progressIndicator.dismiss();
            progressIndicator = null;
        }
    }
}
