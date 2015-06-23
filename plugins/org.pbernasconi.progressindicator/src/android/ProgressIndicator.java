package org.apache.cordova.progressindicator;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import android.app.ProgressDialog;

public class ProgressIndicator extends CordovaPlugin {

    private ProgressDialog progressIndicator = null;
	private static final String LOG_TAG = "ProgressIndicator";

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("show")) {
            show();
            callbackContext.success();
            return true;
        } else if (action.equals("showSimple")) {
            show();
            callbackContext.success();
            return true;
        } else if (action.equals("showSimpleWithLabel")) {
            String title = args.getString(1);
            show(title);
            callbackContext.success();
            return true;
        } else if (action.equals("showSimpleWithLabelDetail")) {
            String title = args.getString(1);
            String text = args.getString(2);
            show(title, text, true);
            callbackContext.success();
            return true;
        } else if (action.equals("showText")) {
            String title = args.getString(1);
			String text = args.getString(2);
            show(title, text, false);
            callbackContext.success();
            return true;
        } else if (action.equals("hide")) {
            hide();
            callbackContext.success();
            return true;
        } else {
            callbackContext.error("Not supported call. On Android we only support show, showSimple, showSimpleWithLabel and showSimpleWithLabelDetail");
		}

        return false;
    }

    /**
     * This show the ProgressDialog
     *
     * @param text - Message to display in the Progress Dialog
     */
    public void show() {
        progressIndicator = new ProgressDialog(cordova.getActivity());
		progressIndicator.show();
    }

    /**
     * This show the ProgressDialog
     *
     * @param text - Message to display in the Progress Dialog
     */
    public void show(String text) {
        progressIndicator = new ProgressDialog(cordova.getActivity());
		progressIndicator.setTitle(text);
		progressIndicator.show();
    }

    /**
     * This show the ProgressDialog
     *
     * @param text - Message to display in the Progress Dialog
     */
    public void show(String title, String detail, Boolean withTitle) {
        progressIndicator = new ProgressDialog(cordova.getActivity());
		if(withTitle)
			progressIndicator.setTitle(title);
		progressIndicator.setMessage(detail);
		progressIndicator.show();
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
