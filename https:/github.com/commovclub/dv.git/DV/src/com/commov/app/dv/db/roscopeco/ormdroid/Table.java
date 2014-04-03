package com.commov.app.dv.db.roscopeco.ormdroid;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Annotation that can be applied to entity classes in order
 * to configure the table name they are mapped to. These options
 * are described in the {@link Entity} documentation.
 * 
 * @author Rosco
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
public @interface Table {
  String name();
}
