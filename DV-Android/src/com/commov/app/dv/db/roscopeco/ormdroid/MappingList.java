package com.commov.app.dv.db.roscopeco.ormdroid;

import java.util.LinkedList;

/*
 * Maintains a list of mappers, and provides functionality for finding
 * a mapper based on assignability.
 * 
 * New mappings are added at the beginning of the list, to allow users 
 * to override default mappings.
 * 
 * NOT THREAD SAFE!
 */
class MappingList {
  private final LinkedList<TypeMapping> mappings = new LinkedList<TypeMapping>();
  
  void addMapping(TypeMapping mapping) {
    mappings.addFirst(mapping);
  }
  
  void removeMapping(TypeMapping mapping) {
    mappings.remove(mapping);
  }
  
  /*
   * Find mapping, or null if none matches.
   */
  TypeMapping findMapping(Class<?> type) {
    for (TypeMapping mapping : mappings) {
      if (mapping.javaType().isAssignableFrom(type)) {
        return mapping;
      }
    }
    return null;
  }
}
