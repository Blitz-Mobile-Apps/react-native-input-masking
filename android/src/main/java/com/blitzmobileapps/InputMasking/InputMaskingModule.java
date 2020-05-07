package com.blitzmobileapps.InputMasking;

import android.graphics.Color;

import androidx.annotation.NonNull;

import com.facebook.react.common.MapBuilder;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import java.util.Map;
import javax.annotation.Nullable;

public class InputMaskingModule extends SimpleViewManager <MaskedInput> {

    public static final String REACT_CLASS = "InputMasking";

    @NonNull
    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @NonNull
    @Override
    protected MaskedInput createViewInstance(@NonNull ThemedReactContext reactContext) {
        return new MaskedInput(reactContext);
    }

    @Override
    public Map getExportedCustomBubblingEventTypeConstants() {

        return MapBuilder.builder()
                .put(
                        "textChange",
                        MapBuilder.of(
                                "phasedRegistrationNames",
                                MapBuilder.of("bubbled", "onChangeText"))
                )
                .put("submitPressed", MapBuilder.of(
                        "phasedRegistrationNames",
                        MapBuilder.of("bubbled", "onSubmitEditing"))
                )
                .put("focusEvent", MapBuilder.of(
                        "phasedRegistrationNames",
                        MapBuilder.of("bubbled", "onFocus"))
                )
                .put("ErrorForMasking", MapBuilder.of(
                        "phasedRegistrationNames",
                        MapBuilder.of("bubbled", "onErrorForMasking"))
                )
                .build();

    }


    @ReactProp(name = "underlineColorAndroid")
    public void setBottomColor(MaskedInput maskedInput, @Nullable String color) {

        maskedInput.setBottomColor(Color.parseColor(color));
    }

    @ReactProp(name = "placeholder")
    public void setPlaceHolder(MaskedInput maskedInput, @Nullable String placeHolder) {
        maskedInput.setPlaceHolder(placeHolder);
    }

    @ReactProp(name = "placeholderTextColor")
    public void setPlaceHolderColor(MaskedInput maskedInput, @Nullable String placeHolderColor) {
        maskedInput.setPlaceHolderColor(Color.parseColor(placeHolderColor));
    }

    @ReactProp(name = "textColor")
    public void setTextColor(MaskedInput maskedInput, @Nullable String TextColor) {
        maskedInput.setTextColor(Color.parseColor(TextColor));
    }

    @ReactProp(name = "disabled")
    public void setEnabled(MaskedInput maskedInput, @Nullable Boolean disable) {
        maskedInput.disabled(disable);
    }

    @ReactProp(name = "value")
    public void setValue(MaskedInput maskedInput, @Nullable String value) {
        maskedInput.setValue(value);
    }

    @ReactProp(name = "textAlign")
    public void setTextAlign(MaskedInput maskedInput, @Nullable String textAlign) {
        maskedInput.setTextAlign(textAlign);
    }

    @ReactProp(name = "keyboardType")
    public void setKeyboardType(MaskedInput maskedInput, @Nullable String keyboardType) {
        maskedInput.setKeyboardType(keyboardType);
    }


    @ReactProp(name = "returnKeyType")
    public void setReturnType(MaskedInput maskedInput, @Nullable String returnType) {
        maskedInput.setReturnType(returnType);
    }

    @ReactProp(name = "maskType")
    public void setMaskType(MaskedInput maskedInput, @Nullable String maskType) {
        maskedInput.setMaskType(maskType);
    }

    @ReactProp(name = "maskFormat")
    public void setMaskFormat(MaskedInput maskedInput, @Nullable String maskFormat) {
        maskedInput.setMaskFormat(maskFormat);
    }


}
