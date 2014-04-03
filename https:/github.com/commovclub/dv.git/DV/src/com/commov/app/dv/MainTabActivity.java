package com.commov.app.dv;

import java.util.ArrayList;
import java.util.List;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.widget.RadioGroup;

import com.commov.app.dv.fragment.FragmentContact;
import com.commov.app.dv.fragment.FragmentEvent;
import com.commov.app.dv.fragment.FragmentMessage;
import com.commov.app.dv.fragment.FragmentMore;
import com.commov.app.dv.fragment.FragmentNews;

public class MainTabActivity extends FragmentActivity {
    /**
     * Called when the activity is first created.
     */
    private RadioGroup rgs;
    public List<Fragment> fragments = new ArrayList<Fragment>();

    public String hello = "hello ";

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        fragments.add(new FragmentNews());
        fragments.add(new FragmentEvent());
        fragments.add(new FragmentContact());
        fragments.add(new FragmentMessage());
        fragments.add(new FragmentMore());


        rgs = (RadioGroup) findViewById(R.id.tabs_rg);

        FragmentTabAdapter tabAdapter = new FragmentTabAdapter(this, fragments, R.id.tab_content, rgs);
        tabAdapter.setOnRgsExtraCheckedChangedListener(new FragmentTabAdapter.OnRgsExtraCheckedChangedListener(){
            @Override
            public void OnRgsExtraCheckedChanged(RadioGroup radioGroup, int checkedId, int index) {
                System.out.println("Extra---- " + index + " checked!!! ");
            }
        });

    }








}

